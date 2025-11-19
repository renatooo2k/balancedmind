import 'package:flutter/material.dart';
import '../widgets/article_card.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  final List<Map<String, String>> articles = const [
    {
      'title': 'Sinais de Burnout',
      'summary': 'Conheça os 8 principais sintomas do esgotamento profissional e como identificar.',
      'url': 'https://www.tuasaude.com/sintomas-da-sindrome-de-burnout/'
    },
    {
      'title': 'Técnica Pomodoro',
      'summary': 'Como usar blocos de tempo de 25 minutos para aumentar o foco e reduzir a fadiga.',
      'url': 'https://napratica.org.br/noticias/pomodoro'
    },
    {
      'title': 'Mindfulness no Trabalho',
      'summary': 'Técnicas de atenção plena para reduzir a ansiedade no ambiente corporativo.',
      'url': 'https://profissoes.vagas.com.br/mindfulness-trabalho/'
    },
    {
      'title': 'A Importância do Sono',
      'summary': 'Como a qualidade do sono afeta a prevenção de doenças e sua produtividade.',
      'url': 'https://www.unimed.coop.br/site/web/cascavel/-/voc%C3%AA-dorme-bem-a-import%C3%A2ncia-do-sono-na-preven%C3%A7%C3%A3o-%C3%A0s-doen%C3%A7as'
    },
    {
      'title': 'Como dizer "Não"',
      'summary': '5 estratégias profissionais para recusar demandas sem parecer preguiçoso.',
      'url': 'https://www.zendesk.com.br/blog/como-dizer-nao-no-trabalho/'
    },
    {
      'title': 'Ergonomia Home Office',
      'summary': 'Melhores práticas para ajustar sua cadeira e monitor e evitar dores.',
      'url': 'https://www.vobi.com.br/blog/ergonomia-home-office-dicas-e-melhores-praticas'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dicas de Bem-Estar'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Biblioteca de Conteúdo',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Artigos selecionados para melhorar seu dia.',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),

          ...articles.map((article) => ArticleCard(
                title: article['title']!,
                summary: article['summary']!,
                url: article['url']!,
              )),
          
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Conteúdo atualizado',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
          ),
        ],
      ),
    );
  }
}