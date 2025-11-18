import 'package:flutter/material.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> _messages = [
    {'role': 'ai', 'text': 'Olá! Sou sua mentora de equilíbrio. Em que posso ajudar hoje? (Dica: Pergunte sobre como lidar com a procrastinação.)'}
  ];
  final TextEditingController _textController = TextEditingController();
  bool _isSending = false;

  // Função preparada para a chamada da API do Chatbot
  Future<void> _sendMessage() async {
    final userMessage = _textController.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': userMessage});
      _textController.clear();
      _isSending = true;
    });

    // --- PONTO DE INTEGRAÇÃO COM API CHATBOT ---
    // Aqui você faria a chamada HTTP (POST) para a API do seu Chatbot.
    // O body JSON DEVE ser: { "message": userMessage }

    // Simulação de resposta da IA
    await Future.delayed(const Duration(seconds: 2));
    final aiResponse = "Essa é uma excelente pergunta! O BalancedMind recomenda que você comece com o exercício 'Pausa de 5 Minutos' na Biblioteca de Pausas para redefinir seu foco. Você gostaria de adicionar essa atividade ao seu log diário?";
    
    if (mounted) {
      setState(() {
        _messages.add({'role': 'ai', 'text': aiResponse});
        _isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentoria IA: Conversa Equilibrada'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return ChatBubble(
                  text: message['text']!,
                  isUser: message['role'] == 'user',
                );
              },
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: (value) => _sendMessage(),
                decoration: const InputDecoration.collapsed(hintText: 'Digite sua dúvida ou desabafo...'),
                enabled: !_isSending,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: _isSending
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}