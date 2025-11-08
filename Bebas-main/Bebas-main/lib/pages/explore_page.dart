import 'package:flutter/material.dart';
import '../services/species_service.dart';
import '../services/threats_service.dart';
import '../services/actions_service.dart';

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
              Tab(text: 'Species'),
              Tab(text: 'Threats'),
              Tab(text: 'Actions'),
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
          return const Center(child: Text('No species data.'));
        }
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, i) {
            final s = list[i];
            return ListTile(
              leading: const Icon(Icons.pets),
              title: Text(s.name),
              subtitle: Text('${s.latin} • ${s.status}'),
            );
          },
        );
      },
    );
  }
}

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
          return const Center(child: Text('No threat data.'));
        }
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
    );
  }
}

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
          return const Center(child: Text('No action tips.'));
        }
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, i) {
            final a = list[i];
            return ListTile(
              leading: const Icon(Icons.volunteer_activism),
              title: Text(a.title),
              subtitle: Text('${a.impact} • ${a.steps}'),
            );
          },
        );
      },
    );
  }
}
