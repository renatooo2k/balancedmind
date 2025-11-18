import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  final String title;
  final String summary;

  const ArticleCard({required this.title, required this.summary, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        color: Colors.white,
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Icon(Icons.menu_book, color: Theme.of(context).colorScheme.secondary),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(summary),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lendo Artigo: $title')),
            );
          },
        ),
      ),
    );
  }
}