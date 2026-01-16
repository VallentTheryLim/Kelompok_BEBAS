import 'package:flutter/material.dart';

import 'sightings_page.dart';
import 'articles_page.dart';
import 'explore_page.dart';
import 'settings_page.dart';
import 'ocean_alerts.dart';
import '../widgets/banner_ad_widget.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _index = 0;

  final List<Widget> _pages = const [
    SightingsPage(),
    ArticlesPage(),
    OceanAlertsPage(),
    ExplorePage(),
    SettingsPage(),
  ];

  final List<String> _titles = const [
    'Home',
    'Articles',
    'Ocean Alerts',
    'Explore',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_index],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /// 📄 HALAMAN UTAMA
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _pages[_index],
            ),
          ),

          /// 📢 BANNER ADMOB
          const BannerAdWidget(),
        ],
      ),

      /// 🔻 NAVIGATION BAR
      bottomNavigationBar: NavigationBar(
        height: 72,
        selectedIndex: _index,
        indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.15),
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.public_outlined),
            selectedIcon: Icon(Icons.public),
            label: 'Articles',
          ),
          NavigationDestination(
            icon: Icon(Icons.warning_amber_outlined),
            selectedIcon: Icon(Icons.warning_amber_rounded),
            label: 'Ocean',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
