// ================================================================
//  services/auth_service.dart
//  Firebase Auth — Admin login / logout / state
// ================================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final _auth = FirebaseAuth.instance;

  // ── Current user stream ──────────────────────────────────────
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Is admin logged in ───────────────────────────────────────
  bool get isLoggedIn => _auth.currentUser != null;

  User? get currentUser => _auth.currentUser;

  // ── Login ────────────────────────────────────────────────────
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      debugPrint('✅ Admin logged in: ${_auth.currentUser?.email}');
      return null; // null = success
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Login error: ${e.code}');
      switch (e.code) {
        case 'user-not-found':
          return 'Admin account nahi mila.';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Email ya password galat hai.';
        case 'too-many-requests':
          return 'Bahut zyada attempts. Thodi der baad try karo.';
        default:
          return 'Login fail hua: ${e.message}';
      }
    }
  }

  // ── Logout ───────────────────────────────────────────────────
  Future<void> logout() async {
    await _auth.signOut();
    debugPrint('✅ Admin logged out');
  }
}
