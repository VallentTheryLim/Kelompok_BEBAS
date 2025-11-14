import 'package:flutter/material.dart';
import '../services/threats_service.dart';

class ThreatsPage extends StatelessWidget {
  const ThreatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ocean Threats')),
      body: FutureBuilder(
        future: ThreatsService.loadThreats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final list = snapshot.data!;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final t = list[i];
              return ListTile(
                leading: const Icon(Icons.warning_amber_rounded),
                title: Text(t.type),
                subtitle: Text('${t.severity} • ${t.description}'),
              );
            },
          );
        },
      ),
    );
  }
}
