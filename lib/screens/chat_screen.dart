import 'package:flutter/material.dart';
import 'dart:convert';
import '../widgets/chat_bubble.dart';
import '../services/api_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> _messages = [
    {'role': 'ai', 'text': 'Olá! Sou sua mentora de equilíbrio. Como você está se sentindo?'}
  ];
  final TextEditingController _textController = TextEditingController();
  bool _isSending = false;

  Future<void> _sendMessage() async {
    final userMessage = _textController.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': userMessage});
      _textController.clear();
      _isSending = true;
    });

    try {
      final response = await ApiService.postAuthenticated(
        '/ai/chat', 
        {
          "message": userMessage,
          "moodRating": 3
        }
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final aiText = data['response'] ?? "Não entendi a resposta.";

        setState(() {
          _messages.add({'role': 'ai', 'text': aiText});
        });
      } else {
        setState(() {
          _messages.add({'role': 'ai', 'text': 'Erro ao processar sua mensagem. Tente novamente.'});
        });
        print("Erro API Chat: ${response.body}");
      }

    } catch (e) {
      print("Erro Chat: $e");
      setState(() {
        _messages.add({'role': 'ai', 'text': 'Erro de conexão. Verifique sua internet.'});
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentoria IA'),
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
                decoration: const InputDecoration.collapsed(hintText: 'Digite aqui...'),
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