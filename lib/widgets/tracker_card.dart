import 'package:flutter/material.dart';

class TrackerCard extends StatelessWidget {
  final String title;
  final Widget child;

  const TrackerCard({required this.title, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 25),
            child,
          ],
        ),
      ),
    );
  }
}