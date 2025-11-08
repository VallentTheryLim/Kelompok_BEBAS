import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../core/storage.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Toggle tema (masih pakai shared_preferences via ThemeProvider)
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: theme.isDark,
            onChanged: (_) => context.read<ThemeProvider>().toggle(),
          ),

          // Info akun dari FirebaseAuth (via AuthProvider)
          ListTile(
            title: const Text('Signed in as'),
            subtitle: Text(auth.email ?? '-'),
          ),

          // Logout pakai FirebaseAuth melalui AuthProvider
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () async {
              await context.read<AuthProvider>().signOut();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out')),
              );
              // Setelah ini, RootGate akan detect isSignedIn = false
              // dan otomatis mengarahkan ke halaman Sign In.
            },
          ),

          const Divider(),

          // Opsional: reset preferensi lokal (tema + status onboarding)
          // Tidak menghapus akun Firebase / tidak logout.
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('Clear all local prefs'),
            subtitle: const Text(
              'Reset tema & onboarding. Tidak menghapus akun atau logout Firebase.',
            ),
            onTap: () async {
              await AppStorage.clearAll();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Local preferences cleared. Restart app.'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
