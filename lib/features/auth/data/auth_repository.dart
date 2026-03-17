import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/app_user.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final _controller = StreamController<AppUser?>();
  AppUser? _currentUser;

  AuthRepository() {
    // Initial state: not logged in
    _controller.add(null);
  }

  Stream<AppUser?> authStateChanges() async* {
    yield _currentUser;
    yield* _controller.stream;
  }

  AppUser? get currentUser => _currentUser;

  Future<void> signInWithGoogle() async {
    // Mock successful Google Sign In
    _currentUser = AppUser(
      uid: 'mock_google_id',
      email: 'mock_user@gmail.com',
      displayName: 'Mock User',
    );
    _controller.add(_currentUser);
  }

  Future<void> signInWithEmail(String email, String password) async {
    // Mock successful Email Sign In
    if (password == 'error') {
      throw 'Mock login failed';
    }
    _currentUser = AppUser(
      uid: 'mock_email_id',
      email: email,
      displayName: email.split('@').first,
    );
    _controller.add(_currentUser);
  }

  Future<void> signUpWithEmail(String email, String password, String name) async {
    // Mock successful Sign Up
    _currentUser = AppUser(
      uid: 'mock_signup_id',
      email: email,
      displayName: name,
    );
    _controller.add(_currentUser);
  }

  Future<void> signOut() async {
    _currentUser = null;
    _controller.add(null);
  }

  Future<void> resetPassword(String email) async {
    // Mock successful password reset
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository();
}
