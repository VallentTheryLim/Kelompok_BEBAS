
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sighting_provider.dart';
import '../models/sighting.dart';

class SightingsPage extends StatefulWidget {
  const SightingsPage({super.key});
  @override
  State<SightingsPage> createState() => _SightingsPageState();
}

class _SightingsPageState extends State<SightingsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<SightingProvider>().load());
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<SightingProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: !prov.loaded
          ? const Center(child: CircularProgressIndicator())
          : (prov.lastError != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, size: 48),
                        const SizedBox(height: 8),
                        Text(prov.lastError!, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        FilledButton(onPressed: () => context.read<SightingProvider>().load(), child: const Text('Retry')),
                      ],
                    ),
                  ),
                )
              : StreamBuilder<List<Sighting>>(
                  stream: prov.stream,
                  builder: (context, snap) {
                    if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                    final data = snap.data!;
                    if (data.isEmpty) {
                      return const Center(child: Text('No sightings yet. Tap + to add one.'));
                    }
                    return ListView.separated(
                      itemCount: data.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final s = data[i];
                        return ListTile(
                          leading: const Icon(Icons.waves),
                          title: Text(s.species),
                          subtitle: Text('${s.location} • ${s.date.toLocal()}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => context.read<SightingProvider>().remove(s.id!),
                          ),
                        );
                      },
                    );
                  },
                )),
      floatingActionButton: prov.lastError == null
          ? FloatingActionButton(
              onPressed: () async {
                final result = await showDialog<Sighting>(
                  context: context,
                  builder: (_) => const _AddDialog(),
                );
                if (result != null) {
                  await context.read<SightingProvider>().add(result);
                }
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class _AddDialog extends StatefulWidget {
  const _AddDialog();
  @override
  State<_AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<_AddDialog> {
  final _formKey = GlobalKey<FormState>();
  final _species = TextEditingController();
  final _location = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Sighting'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _species,
                decoration: const InputDecoration(labelText: 'Species (e.g., Sea Turtle)'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _location,
                decoration: const InputDecoration(labelText: 'Location (e.g., Coral Reef 3)'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.pop(
                context,
                Sighting(species: _species.text.trim(), location: _location.text.trim(), date: DateTime.now()),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
