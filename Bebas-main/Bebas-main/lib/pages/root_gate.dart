
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../providers/auth_provider.dart';
import 'onboarding_page.dart';
import 'sign_router.dart';
import 'shell.dart';

class RootGate extends StatelessWidget {
  const RootGate({super.key});

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
