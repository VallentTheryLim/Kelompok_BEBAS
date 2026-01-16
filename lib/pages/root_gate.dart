import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../providers/auth_provider.dart';
import '../services/fcm_service.dart';
import 'onboarding_page.dart';
import 'sign_router.dart';
import 'shell.dart';

class RootGate extends StatefulWidget {
  const RootGate({super.key});

  @override
  State<RootGate> createState() => _RootGateState();
}

class _RootGateState extends State<RootGate> {
  @override
  void initState() {
    super.initState();

    /// 🔔 PANGGIL FCM SEKALI SAAT APP DIBUKA
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FCMService().init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ob = context.watch<OnboardingProvider>();
    final auth = context.watch<AuthProvider>();

    if (!ob.done) {
      return const OnboardingPage();
    }
    if (!auth.isSignedIn) {
      return const SignRouter();
    }
    return const Shell();
  }
}
