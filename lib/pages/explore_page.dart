import 'package:flutter/material.dart';
import '../services/species_service.dart';
import '../services/threats_service.dart';
import '../services/actions_service.dart';
import '../pages/species_detail_page.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Explore Ocean Data'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.pets), text: 'Species'),
              Tab(icon: Icon(Icons.warning_amber_rounded), text: 'Threats'),
              Tab(icon: Icon(Icons.volunteer_activism), text: 'Actions'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _SpeciesTab(),
            _ThreatsTab(),
            _ActionsTab(),
          ],
        ),
      ),
    );
  }
}

// =======================
// 🐠 SPECIES TAB
// =======================
class _SpeciesTab extends StatelessWidget {
  const _SpeciesTab();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SpeciesService.loadSpecies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final list = snapshot.data!;
        if (list.isEmpty) {
          return const Center(child: Text('No species data available.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: list.length,
          itemBuilder: (context, i) {
            final s = list[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.pets),
                title: Text(s.name),
                subtitle: Text('${s.latin} • ${s.status}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SpeciesDetailPage(species: s),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

// =======================
// ⚠️ THREATS TAB
// =======================
class _ThreatsTab extends StatelessWidget {
  const _ThreatsTab();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
                subtitle: Text('${t.severity} • ${t.description}'),
              ),
            );
          },
        );
      },
    );
  }
}

// =======================
// 🤝 ACTIONS TAB
// =======================
class _ActionsTab extends StatelessWidget {
  const _ActionsTab();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
          return const Center(child: Text('No action tips available.'));
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
                subtitle: Text('${a.impact} • ${a.steps}'),
              ),
            );
          },
        );
      },
    );
  }
}
