import 'package:flutter/material.dart';
import '../services/actions_service.dart';

class ActionsPage extends StatelessWidget {
  const ActionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conservation Actions')),
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
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final a = list[i];
              return ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: Text(a.title),
                subtitle: Text('${a.impact} • ${a.steps}'),
              );
            },
          );
        },
      ),
    );
  }
}
