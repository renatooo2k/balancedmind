import 'package:flutter/material.dart';
import '../widgets/tracker_card.dart';

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

  final Map<String, String> _emojiMap = {
    '😩': 'Muito Estressado',
    '😔': 'Um pouco Desanimado',
    '🙂': 'Neutro/Bom',
    '😊': 'Feliz/Motivado',
    '🥳': 'Excelente/Produtivo',
  };

  // Função preparada para salvar os dados no backend/database
  Future<void> _saveDailyLog() async {
    setState(() {
      _isSaving = true;
    });

    // --- PONTO DE INTEGRAÇÃO COM BACKEND: SALVAR LOG (ATUALIZADO) ---
    // O body JSON agora inclui "horas_foco"
    // {
    //   "data": "2024-01-01", // (O backend deve gerar a data atual)
    //   "horas_foco": _focusHours,
    //   "qualidade_descanso": _restQuality,
    //   "emocional": _selectedEmoji
    // }
    
    // Simulação de espera do backend
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isSaving = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Log Diário salvo com sucesso! As métricas PL/SQL serão atualizadas.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitor de Equilíbrio Diário'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Registre seu dia para visualizar padrões e manter a saúde.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 30),

            TrackerCard(
              title: '1. Tempo de Foco (Horas Trabalhadas)',
              child: Column(
                children: [
                  Slider(
                    value: _focusHours,
                    min: 0,
                    max: 12,
                    divisions: 12,
                    label: _focusHours.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _focusHours = value;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('0h', style: TextStyle(fontSize: 12)),
                        Text('12h', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${_focusHours.toStringAsFixed(0)} horas', // Display principal
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            TrackerCard(
              title: '2. Qualidade do Seu Descanso (1 a 5)',
              child: Column(
                children: [
                  Slider(
                    value: _restQuality,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: _restQuality.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _restQuality = value;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('1 - Ruim', style: TextStyle(fontSize: 12)),
                      Text('5 - Excelente', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            TrackerCard(
              title: '3. Seu Nível Emocional Geral Hoje',
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _emojiMap.keys.map((emoji) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedEmoji = emoji;
                          });
                        },
                        child: CircleAvatar(
                          radius: _selectedEmoji == emoji ? 25 : 20,
                          backgroundColor: _selectedEmoji == emoji ? Theme.of(context).colorScheme.secondary.withOpacity(0.3) : Colors.transparent,
                          child: Text(emoji, style: const TextStyle(fontSize: 30)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Text('Você se sente: ${_emojiMap[_selectedEmoji]}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Botão de Salvar Log
            Center(
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: _saveDailyLog,
                      icon: const Icon(Icons.save),
                      label: const Text('Salvar Log do Dia'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 50),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}