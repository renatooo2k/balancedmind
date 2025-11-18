import 'package:flutter/material.dart';
import '../widgets/article_card.dart'; 

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  // Simulação de lista de artigos (idealmente viria de um backend/Firestore)
  final List<Map<String, String>> articles = const [
    {'title': 'O Poder do Desligamento Digital', 'summary': 'Como pausas estratégicas de tela melhoram sua produtividade.'},
    {'title': 'Mindfulness no Escritório', 'summary': '5 exercícios de atenção plena para fazer na sua cadeira.'},
    {'title': 'A Regra 80/20 do Equilíbrio', 'summary': 'Foque no que realmente importa para a sua vida pessoal e profissional.'},
    {'title': 'Como Dizer Não Sem Culpa', 'summary': 'Estratégias para estabelecer limites saudáveis no trabalho.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dicas e Artigos de Bem-Estar'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Explore insights para uma vida mais equilibrada.',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          ...articles.map((article) => ArticleCard(
                title: article['title']!,
                summary: article['summary']!,
              )),
          const SizedBox(height: 10),
          Center(
            child: TextButton.icon(
              onPressed: () {
                // Simulação: Chamada da API/BD para carregar mais itens
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ação: Chamando API para buscar mais artigos de Bem-Estar.')),
                );
              },
              icon: const Icon(Icons.arrow_downward),
              label: const Text('Carregar Mais Dicas'),
            ),
          )
        ],
      ),
    );
  }
}