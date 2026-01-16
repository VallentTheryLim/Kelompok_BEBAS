import 'package:flutter/material.dart';
import '../services/actions_service.dart';
import 'action_detail_page.dart';

class ActionsPage extends StatelessWidget {
  const ActionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ocean Actions'),
      ),
      body: FutureBuilder(
        future: ActionsService.loadActions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final list = snapshot.data!;
          if (list.isEmpty) {
            return const Center(child: Text('No action data available.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final a = list[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.volunteer_activism),
                  title: Text(a.title),
                  subtitle: Text(a.impact),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ActionDetailPage(action: a),
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
