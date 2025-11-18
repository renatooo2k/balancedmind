import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatBubble({required this.text, required this.isUser, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: isUser ? Theme.of(context).primaryColor.withOpacity(0.9) : Theme.of(context).colorScheme.secondary.withOpacity(0.9),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16.0),
                  topRight: const Radius.circular(16.0),
                  bottomLeft: isUser ? const Radius.circular(16.0) : const Radius.circular(4.0),
                  bottomRight: isUser ? const Radius.circular(4.0) : const Radius.circular(16.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                text,
                style: TextStyle(color: isUser ? Colors.white : Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}