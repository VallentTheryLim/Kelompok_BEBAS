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
      appBar: AppBar(
        title: const Text('Home Dashboard'),
        centerTitle: true,
      ),
      body: !prov.loaded
          ? const Center(child: CircularProgressIndicator())
          : prov.lastError != null
              ? _ErrorState(message: prov.lastError!)
              : StreamBuilder<List<Sighting>>(
                  stream: prov.stream,
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final data = snap.data!;

                    return RefreshIndicator(
                      onRefresh: () async =>
                          context.read<SightingProvider>().load(),
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          /// 🔹 DASHBOARD CARD
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  const Icon(Icons.waves,
                                      size: 48, color: Colors.blue),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Total Sightings',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        '${data.length}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          /// 🔹 SECTION TITLE
                          const Text(
                            'Recent Sightings',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),

                          if (data.isEmpty)
                            const _EmptyState()
                          else
                            ...data.map(
                              (s) => Card(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  leading: const Icon(Icons.public),
                                  title: Text(s.species),
                                  subtitle: Text(
                                    '${s.location}\n${s.date.toLocal()}',
                                  ),
                                  isThreeLine: true,
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => context
                                        .read<SightingProvider>()
                                        .remove(s.id!),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),

      /// ➕ ADD BUTTON
      floatingActionButton: prov.lastError == null
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              label: const Text('Add Sighting'),
              onPressed: () async {
                final result = await showDialog<Sighting>(
                  context: context,
                  builder: (_) => const _AddDialog(),
                );
                if (result != null) {
                  await context.read<SightingProvider>().add(result);
                }
              },
            )
          : null,
    );
  }
}

/// 🔴 ERROR STATE
class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.read<SightingProvider>().load(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 📭 EMPTY STATE
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: const [
          Icon(Icons.inbox_outlined, size: 64),
          SizedBox(height: 12),
          Text(
            'No sightings yet.\nTap "Add Sighting" to report.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// ➕ ADD DIALOG
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _species,
              decoration: const InputDecoration(labelText: 'Species'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: _location,
              decoration: const InputDecoration(labelText: 'Location'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.pop(
                context,
                Sighting(
                  species: _species.text.trim(),
                  location: _location.text.trim(),
                  date: DateTime.now(),
                ),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
