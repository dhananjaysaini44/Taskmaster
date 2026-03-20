import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/auth_repository.dart';
import '../domain/auth_state.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  FutureOr<AuthState> build() async {
    final repo = ref.watch(authRepositoryProvider);
    
    // Listen to auth state changes and update this notifier
    final subscription = repo.authStateChanges().listen((user) {
      if (user != null) {
        state = AsyncData(AuthState.authenticated(user));
      } else {
        state = const AsyncData(AuthState.unauthenticated());
      }
    });

    ref.onDispose(() => subscription.cancel());

    // Initial state
    final user = repo.currentUser;
    if (user != null) {
      return AuthState.authenticated(user);
    }
    return const AuthState.unauthenticated();
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signInWithGoogle();
      // Let the stream listener handle the actual state update
      return state.value ?? const AuthState.unauthenticated();
    });
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signInWithEmail(email, password);
      return state.value ?? const AuthState.unauthenticated();
    });
  }

  Future<void> signUpWithEmail(String email, String password, String name) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signUpWithEmail(email, password, name);
      return state.value ?? const AuthState.unauthenticated();
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signOut();
      return const AuthState.unauthenticated();
    });
  }

  Future<void> resetPassword(String email) async {
    // This doesn't change the auth state, so we just perform the action
    await ref.read(authRepositoryProvider).resetPassword(email);
  }

  Future<void> updateDisplayName(String name) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).updateDisplayName(name);
      return state.value ?? const AuthState.unauthenticated();
    });
  }

  Future<void> updatePassword(String newPassword) async {
    // Password update doesn't typically change the AuthState user object immediately in a way we track here
    // but it's an auth operation.
    await ref.read(authRepositoryProvider).updatePassword(newPassword);
  }
}
