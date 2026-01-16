import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'providers/theme_provider.dart';
import 'providers/sighting_provider.dart';
import 'providers/onboarding_provider.dart';
import 'providers/auth_provider.dart';
import 'pages/root_gate.dart';

/// 🔔 FCM background handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 🔥 Firebase init
  await Firebase.initializeApp();

  /// 🔔 FCM background listener
  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );

  /// 📢 AdMob init
  await MobileAds.instance.initialize();

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
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Life Below Water+',

            /// 🔥 KUNCI UTAMA UI KONSISTEN
            themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,
            theme: theme.lightTheme,
            darkTheme: theme.darkTheme,

            home: const RootGate(),
          );
        },
      ),
    );
  }
}
