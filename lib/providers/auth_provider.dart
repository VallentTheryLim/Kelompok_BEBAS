import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;
  bool get isSignedIn => user != null;
  String? get email => user?.email;

  AuthProvider() {
    _auth.authStateChanges().listen((_) {
      notifyListeners();
    });
  }

  Future<void> signUp(String email, String password) async {
    if (email.trim().isEmpty || password.length < 6) {
      throw Exception('Email tidak boleh kosong dan password minimal 6 karakter');
    }
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Gagal mendaftar');
    }
  }

  Future<void> signIn(String email, String password) async {
    if (email.trim().isEmpty || password.isEmpty) {
      throw Exception('Email/password tidak boleh kosong');
    }
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Gagal login: ${e.message}');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
