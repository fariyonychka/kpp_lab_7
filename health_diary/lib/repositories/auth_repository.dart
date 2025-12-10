import 'package:firebase_auth/firebase_auth.dart';
import '../core/app_strings.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
    required int age,
    required String gender,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await cred.user?.updateDisplayName(name);
      await cred.user?.reload();
      return cred.user;
    } on FirebaseAuthException catch (e) {
      throw _handleException(e);
    }
  }

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      throw _handleException(e);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleException(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  User? get currentUser => _auth.currentUser;

  String _handleException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Пароль занадто слабкий';
      case 'email-already-in-use':
        return 'Цей email вже використовується';
      case 'invalid-email':
        return AppStrings.emailInvalid;
      case 'user-not-found':
      case 'wrong-password':
        return 'Невірний email або пароль';
      default:
        return e.message ?? AppStrings.authFailed;
    }
  }
}
