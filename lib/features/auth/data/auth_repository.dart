import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart'
    as gplus;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../firebase_options.dart';
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
    try {
      // Configuration for Google Sign-In
      // Determine Client ID based on platform
      String? clientId;
      String clientSecret = '';

      if (kIsWeb) {
        // Web usually handles this via Firebase config, but google_sign_in_all_platforms might need it
        clientId = DefaultFirebaseOptions
            .web
            .iosClientId; // Search for web specific if available
      } else {
        switch (defaultTargetPlatform) {
          case TargetPlatform.iOS:
          case TargetPlatform.macOS:
            clientId = DefaultFirebaseOptions.ios.iosClientId;
            break;
          case TargetPlatform.android:
            // Android Client ID from google-services.json
            clientId =
                '601550085633-oaaj38pchpmt4muirq72dlo4ij6ct2r1.apps.googleusercontent.com';
            break;
          case TargetPlatform.windows:
            // CRITICAL: Windows requires a "Desktop" client ID from Google Cloud Console.
            // The iOS client ID (default) WILL NOT WORK on Windows.
            // Placeholder: Replace with your actual Desktop Client ID.
            clientId =
                '601550085633-aatmka9c86arn9fb5pirdfuskre2sdqb.apps.googleusercontent.com';
            clientSecret =
                ''; // Desktop apps usually need a client secret or specific config
            break;
          default:
            clientId = null;
        }
      }

      final googleSignIn = gplus.GoogleSignIn(
        params: gplus.GoogleSignInParams(
          clientId: clientId,
          clientSecret: clientSecret,
          scopes: ['openid', 'email', 'profile'],
        ),
      );

      // Perform sign in
      final result = await googleSignIn.signIn();

      if (result == null) {
        // Log this to console to help the user see what's happening
        debugPrint('Google Sign-In returned null. This usually means:');
        debugPrint('1. The user cancelled the sign-in.');
        debugPrint(
          '2. The Client ID is incorrect for this platform (especially on Windows).',
        );
        debugPrint('3. The OAuth consent screen is not configured correctly.');
        throw Exception(
          'Google Sign-In was cancelled or failed. Please check the console for details.',
        );
      }

      // Obtain tokens
      final idToken = result.idToken;
      final accessToken = result.accessToken;

      if (idToken == null) {
        throw Exception('Failed to obtain ID token from Google');
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        final appUser = AppUser(
          uid: firebaseUser.uid,
          email: firebaseUser.email,
          displayName: firebaseUser.displayName,
          photoURL: firebaseUser.photoURL,
        );

        // Save/Update user in Firestore
        await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .set(appUser.toMap(), SetOptions(merge: true));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
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
      _firestore.collection('users').doc(user.uid).update({
        'displayName': name,
      }),
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
