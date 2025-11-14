import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; 

import 'providers/theme_provider.dart';
import 'providers/sighting_provider.dart';
import 'providers/onboarding_provider.dart';
import 'providers/auth_provider.dart';
import 'pages/root_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const LifeBelowWaterApp());
}

class LifeBelowWaterApp extends StatelessWidget {
  const LifeBelowWaterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SightingProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) {
          final lightScheme = ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          );
          final darkScheme = ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          );

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Life Below Water+',
            themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: lightScheme,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: darkScheme,
              brightness: Brightness.dark,
            ),
            home: const RootGate(),
          );
        },
      ),
    );
  }
}
