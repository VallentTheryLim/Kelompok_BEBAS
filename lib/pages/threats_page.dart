import 'package:flutter/material.dart';
import '../services/threats_service.dart';
import 'threat_detail_page.dart';

class ThreatsPage extends StatelessWidget {
  const ThreatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ocean Threats'),
      ),
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
          if (list.isEmpty) {
            return const Center(child: Text('No threat data available.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final t = list[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.warning_amber_rounded),
                  title: Text(t.type),
                  subtitle: Text(t.severity),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ThreatDetailPage(threat: t),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
