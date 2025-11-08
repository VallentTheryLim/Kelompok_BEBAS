
import 'package:flutter/foundation.dart';
import '../core/storage.dart';

class OnboardingProvider with ChangeNotifier {
  bool _done = false;
  bool get done => _done;

  OnboardingProvider() {
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    _done = await AppStorage.isOnboardingDone();
    notifyListeners();
  }

  Future<void> setDone() async {
    await AppStorage.setOnboardingDone(true);
    _done = true;
    notifyListeners();
  }
}
