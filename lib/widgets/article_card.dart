import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleCard extends StatelessWidget {
  final String title;
  final String summary;
  final String url;

  const ArticleCard({
    required this.title,
    required this.summary,
    required this.url,
    super.key,
  });

  Future<void> _launchURL(BuildContext context) async {
    final Uri uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível abrir o link: $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        color: Colors.white,
        elevation: 2,
        child: InkWell(
          onTap: () => _launchURL(context),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.article_outlined, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    const Icon(Icons.open_in_new, size: 18, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  summary,
                  style: TextStyle(color: Colors.grey.shade700, height: 1.3),
                ),
                const SizedBox(height: 8),
                Text(
                  "Toque para ler mais",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}