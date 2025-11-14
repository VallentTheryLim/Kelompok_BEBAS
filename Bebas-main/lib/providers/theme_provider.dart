
import 'package:flutter/material.dart';
import '../core/storage.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeProvider() {
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    _isDark = await AppStorage.isDarkMode();
    notifyListeners();
  }

  Future<void> toggle() async {
    _isDark = !_isDark;
    await AppStorage.setDarkMode(_isDark);
    notifyListeners();
  }
}
