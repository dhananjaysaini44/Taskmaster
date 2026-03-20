import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/app_user.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _authBox = Hive.box('authBox');
  final _controller = StreamController<AppUser?>();
  AppUser? _currentUser;

  AuthRepository() {
    // Initial load from Hive (Session Persistence)
    _currentUser = _authBox.get('currentUser');
    _controller.add(_currentUser);

    // Sync with Firebase auth changes
    _auth.authStateChanges().listen((User? user) async {
      if (user == null) {
        _currentUser = null;
        _authBox.delete('currentUser');
        _controller.add(null);
      } else {
        // Initial user from Auth
        var appUser = AppUser(
          uid: user.uid,
          email: user.email,
          displayName: user.displayName,
          photoURL: user.photoURL,
        );

        // Enrich with Firestore data if available
        try {
          final doc = await _firestore.collection('users').doc(user.uid).get();
          if (doc.exists && doc.data() != null) {
            final firestoreUser = AppUser.fromMap(doc.data()!);
            appUser = AppUser(
              uid: appUser.uid,
              email: appUser.email,
              displayName: firestoreUser.displayName ?? appUser.displayName,
              photoURL: firestoreUser.photoURL ?? appUser.photoURL,
            );
          }
        } catch (e) {
          // Fallback to Auth info if Firestore fails
        }

        _currentUser = appUser;
        _authBox.put('currentUser', _currentUser);
        _controller.add(_currentUser);
      }
    });
  }

  Stream<AppUser?> authStateChanges() => _controller.stream;

  AppUser? get currentUser => _currentUser;

  Future<void> signInWithGoogle() async {
    // Note: Google Sign-In requires extra platform setup (Web/Android/iOS)
    // For now, this will trigger the real Firebase flow if set up.
    throw UnimplementedError('Google Sign-In requires additional platform configuration.');
  }

  Future<void> signInWithEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUpWithEmail(String email, String password, String name) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    final user = AppUser(
      uid: credential.user!.uid,
      email: email,
      displayName: name,
    );

    await Future.wait([
      credential.user!.updateDisplayName(name),
      _firestore.collection('users').doc(user.uid).set(user.toMap()),
    ]);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateDisplayName(String name) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    await Future.wait([
      user.updateDisplayName(name),
      _firestore.collection('users').doc(user.uid).update({'displayName': name}),
    ]);

    // Force refresh of current user object
    final updatedAppUser = _currentUser?.copyWith(displayName: name);
    if (updatedAppUser != null) {
      _currentUser = updatedAppUser;
      _authBox.put('currentUser', _currentUser);
      _controller.add(_currentUser);
    }
  }

  Future<void> updatePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user found');
    await user.updatePassword(newPassword);
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository();
}
