import 'package:flutter/material.dart';
import '../services/species_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SpeciesPage extends StatelessWidget {
  const SpeciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marine Species')),
      body: FutureBuilder(
        future: SpeciesService.loadSpecies(),
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
              final s = list[i];
              return ListTile(
                leading: Icon(MdiIcons.fish, size: 28),
                title: Text(s.name),
                subtitle: Text('${s.latin} • ${s.status}'),
              );
            },
          );
        },
      ),
    );
  }
}
