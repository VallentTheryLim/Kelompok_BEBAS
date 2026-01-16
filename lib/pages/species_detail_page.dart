import 'package:flutter/material.dart';

class SpeciesDetailPage extends StatelessWidget {
  final dynamic species;

  const SpeciesDetailPage({
    super.key,
    required this.species,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(species.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              species.latin,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text('Status: ${species.status}'),
            const SizedBox(height: 20),
            Text(
              species.description ?? '-',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
