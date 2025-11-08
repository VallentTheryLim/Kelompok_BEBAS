import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../services/ocean_alert_service.dart';

class OceanAlertsPage extends StatelessWidget {
  const OceanAlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ocean Alerts (Cloud)')),
      body: StreamBuilder<QuerySnapshot>(
        stream: OceanAlertService.streamAlerts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada laporan. Tambah laporan kondisi laut dengan tombol +.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final d = docs[i];
              final data = d.data() as Map<String, dynamic>;
              final type = (data['type'] ?? '-') as String;
              final location = (data['location'] ?? '-') as String;
              final description = (data['description'] ?? '-') as String;
              final severity = (data['severity'] ?? 1) as int;
              final ts = data['date'];
              final photoUrl = data['photoUrl'] as String?;
              final dateText = ts is Timestamp
                  ? ts.toDate().toLocal().toString()
                  : (ts?.toString() ?? '');

              return ListTile(
                leading: Icon(
                  Icons.warning_amber_rounded,
                  color: severity >= 4 ? Colors.red : Colors.orange,
                ),
                title: Text('$type • Level $severity'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$location • $dateText'),
                    Text(description),
                    if (photoUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            photoUrl,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => OceanAlertService.deleteAlert(d.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final alert = await showDialog<_AlertInput>(
            context: context,
            builder: (context) => const _AddAlertDialog(),
          );
          if (alert != null) {
            try {
              await OceanAlertService.addAlert(
                type: alert.type,
                location: alert.location,
                description: alert.description,
                severity: alert.severity,
                photoFile: alert.photoFile,
              );
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.toString())),
              );
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _AlertInput {
  final String type;
  final String location;
  final String description;
  final int severity;
  final File? photoFile;
  _AlertInput(this.type, this.location, this.description, this.severity, this.photoFile);
}

class _AddAlertDialog extends StatefulWidget {
  const _AddAlertDialog({super.key});

  @override
  State<_AddAlertDialog> createState() => _AddAlertDialogState();
}

class _AddAlertDialogState extends State<_AddAlertDialog> {
  final _formKey = GlobalKey<FormState>();
  final _location = TextEditingController();
  final _description = TextEditingController();
  String _type = 'Plastic Pollution';
  double _severity = 3;
  XFile? _pickedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (img != null) {
      setState(() => _pickedImage = img);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Laporan Laut'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(
                    value: 'Plastic Pollution',
                    child: Text('Plastic Pollution'),
                  ),
                  DropdownMenuItem(
                    value: 'Coral Damage',
                    child: Text('Coral Damage'),
                  ),
                  DropdownMenuItem(
                    value: 'Overfishing',
                    child: Text('Overfishing'),
                  ),
                  DropdownMenuItem(
                    value: 'Endangered Species',
                    child: Text('Endangered Species Sighting'),
                  ),
                ],
                onChanged: (v) => setState(() => _type = v ?? _type),
                decoration: const InputDecoration(labelText: 'Jenis Laporan'),
              ),
              TextFormField(
                controller: _location,
                decoration: const InputDecoration(labelText: 'Lokasi (pantai/laut)'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _description,
                decoration: const InputDecoration(labelText: 'Deskripsi kejadian'),
                maxLines: 3,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              Text('Tingkat keparahan: ${_severity.round()}'),
              Slider(
                value: _severity,
                min: 1,
                max: 5,
                divisions: 4,
                label: _severity.round().toString(),
                onChanged: (v) => setState(() => _severity = v),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo),
                    label: const Text('Pilih Foto (opsional)'),
                  ),
                  const SizedBox(width: 8),
                  if (_pickedImage != null)
                    const Icon(Icons.check, color: Colors.green),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () {
            if (!(_formKey.currentState?.validate() ?? false)) return;
            Navigator.pop(
              context,
              _AlertInput(
                _type,
                _location.text.trim(),
                _description.text.trim(),
                _severity.round(),
                _pickedImage != null ? File(_pickedImage!.path) : null,
              ),
            );
          },
          child: const Text('Kirim'),
        ),
      ],
    );
  }
}
