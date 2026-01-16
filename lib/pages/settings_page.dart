import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../core/storage.dart';
import 'debug_fcm_page.dart';

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
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: theme.isDark,
            onChanged: (_) => context.read<ThemeProvider>().toggle(),
          ),

          ListTile(
            title: const Text('Signed in as'),
            subtitle: Text(auth.email ?? '-'),
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () async {
              await context.read<AuthProvider>().signOut();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out')),
              );
            },
          ),

          const Divider(),

          /// 🔔 FCM TOKEN (BUKTI IMPLEMENTASI)
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('FCM Token'),
            subtitle: const Text('View Firebase Cloud Messaging token'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DebugFCMPage(),
                ),
              );
            },
          ),

          const Divider(),

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
