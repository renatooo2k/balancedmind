import 'package:flutter/material.dart';
import 'dart:convert';
import '../widgets/tracker_card.dart';
import '../services/api_service.dart';

class BalanceTrackerScreen extends StatefulWidget {
  const BalanceTrackerScreen({super.key});

  @override
  State<BalanceTrackerScreen> createState() => _BalanceTrackerScreenState();
}

class _BalanceTrackerScreenState extends State<BalanceTrackerScreen> {
  double _focusHours = 8.0;
  double _restQuality = 3.0;
  String _selectedEmoji = '🙂';
  bool _isSaving = false;
  bool _isLoadingHistory = true;

  final Map<String, String> _emojiMap = {
    '😩': 'Muito Estressado',
    '😔': 'Um pouco Desanimado',
    '🙂': 'Neutro/Bom',
    '😊': 'Feliz/Motivado',
    '🥳': 'Excelente/Produtivo',
  };

  String _getEmojiLabel(String emoji) {
    switch (emoji) {
      case '😩': return 'Pessimo';
      case '😔': return 'Ruim';
      case '🙂': return 'Neutro';
      case '😊': return 'Bom';
      case '🥳': return 'Otimo';
      default: return 'Neutro';
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveDailyLog() async {
    setState(() => _isSaving = true);

    try {
      final Map<String, dynamic> bodyData = {
        "worktime": _focusHours.toInt(),
        "restQuality": _restQuality.toInt(),
        "emotionalState": _getEmojiLabel(_selectedEmoji)
      };

      final response = await ApiService.postAuthenticated('/monitor', bodyData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registro diário salvo com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        print("Erro Monitor: ${response.body}");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao salvar: ${response.statusCode}'), 
              backgroundColor: Colors.red
            ),
          );
        }
      }
    } catch (e) {
      print("Erro exceção: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro de conexão.'), 
            backgroundColor: Colors.red
          ),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitor de Equilíbrio'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Como foi o seu dia hoje?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold, 
                color: const Color(0xFF1F2937)
              ),
            ),
            const SizedBox(height: 20),

            TrackerCard(
              title: '1. Tempo de Foco (Horas)',
              child: Column(
                children: [
                  Slider(
                    value: _focusHours,
                    min: 0,
                    max: 12,
                    divisions: 12,
                    label: _focusHours.round().toString(),
                    onChanged: (v) => setState(() => _focusHours = v),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Text('0h'), Text('12h')],
                    ),
                  ),
                  Text(
                    '${_focusHours.toInt()} horas', 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            TrackerCard(
              title: '2. Qualidade do Descanso',
              child: Column(
                children: [
                  Slider(
                    value: _restQuality,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: _restQuality.round().toString(),
                    onChanged: (v) => setState(() => _restQuality = v),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [Text('Ruim'), Text('Excelente')],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            TrackerCard(
              title: '3. Como se sente?',
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _emojiMap.keys.map((emoji) {
                      return GestureDetector(
                        onTap: () => setState(() => _selectedEmoji = emoji),
                        child: CircleAvatar(
                          radius: _selectedEmoji == emoji ? 24 : 20,
                          // Uso de .withValues para compatibilidade
                          backgroundColor: _selectedEmoji == emoji 
                              ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3) 
                              : Colors.transparent,
                          child: Text(emoji, style: const TextStyle(fontSize: 28)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _emojiMap[_selectedEmoji]!, 
                    style: const TextStyle(fontWeight: FontWeight.bold)
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveDailyLog,
                icon: _isSaving 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.check_circle),
                label: Text(_isSaving ? 'Salvando...' : 'Registrar Dia'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}