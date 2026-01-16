
import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static const _kDarkMode = 'is_dark';
  static const _kOnboardingDone = 'onboarding_done';
  static const _kAuthEmail = 'auth_email';

  static Future<bool> isDarkMode() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_kDarkMode) ?? false;
  }
  static Future<void> setDarkMode(bool value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kDarkMode, value);
  }

  static Future<bool> isOnboardingDone() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_kOnboardingDone) ?? false;
  }
  static Future<void> setOnboardingDone(bool value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kOnboardingDone, value);
  }

  static Future<String?> getAuthEmail() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kAuthEmail);
  }
  static Future<void> setAuthEmail(String? email) async {
    final sp = await SharedPreferences.getInstance();
    if (email == null) {
      await sp.remove(_kAuthEmail);
    } else {
      await sp.setString(_kAuthEmail, email);
    }
  }

  static Future<void> clearAll() async {
    final sp = await SharedPreferences.getInstance();
    await sp.clear();
  }
}
