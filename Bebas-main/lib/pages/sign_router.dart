
import 'package:flutter/material.dart';
import 'sign_in_page.dart';
import 'sign_up_page.dart';

class SignRouter extends StatelessWidget {
  const SignRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/signin',
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/signin':
            page = const SignInPage();
            break;
          case '/signup':
            page = const SignUpPage();
            break;
          default:
            page = const SignInPage();
        }
        return MaterialPageRoute(builder: (_) => page, settings: settings);
      },
    );
  }
}
