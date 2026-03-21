import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/splash/presentation/providers/splash_provider.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/tasks/presentation/tasks_screen.dart';
import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/mindmap/presentation/mind_map_screen.dart';
import '../../shared/widgets/main_app_shell.dart';

part 'app_router.g.dart';

class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(Ref ref) {
    ref.listen(authProvider, (_, _) => notifyListeners());
  }
}

@riverpod
RouterRefreshNotifier routerRefresh(RouterRefreshRef ref) =>
    RouterRefreshNotifier(ref);

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final refreshListenable = ref.watch(routerRefreshProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final authValue = authState.valueOrNull;
      final splashFinished = ref.watch(splashFinishedProvider);

      final isSplash = state.uri.path == '/splash';
      final isAuthRoute =
          state.uri.path == '/login' || state.uri.path == '/signup';

      // 1. Wait for splash to finish if we are on splash
      if (isSplash && !splashFinished) {
        return null;
      }

      // 2. Handle Loading/Initialization
      if (authState.isLoading) {
        if (isSplash || isAuthRoute) return null;
        return '/splash';
      }

      // 3. Handle Case where state is null
      if (authValue == null) {
        if (isAuthRoute) return null;
        return '/login';
      }

      final isAuth = authValue.maybeMap(
        authenticated: (_) => true,
        orElse: () => false,
      );

      // 4. Force Login if unauthenticated
      if (!isAuth) {
        if (isAuthRoute) return null;
        return '/login';
      }

      // 5. Force Home if authenticated and trying to access splash/login/signup
      if (isSplash || isAuthRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) =>
            FadeTransitionPage(child: const SplashScreen(), key: state.pageKey),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) =>
            FadeTransitionPage(child: const LoginScreen(), key: state.pageKey),
      ),
      GoRoute(
        path: '/signup',
        pageBuilder: (context, state) =>
            FadeTransitionPage(child: const SignupScreen(), key: state.pageKey),
      ),
      ShellRoute(
        builder: (context, state, child) => MainAppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => FadeTransitionPage(
              child: const HomeScreen(),
              key: state.pageKey,
            ),
          ),
          GoRoute(
            path: '/tasks',
            pageBuilder: (context, state) => FadeTransitionPage(
              child: const TasksScreen(),
              key: state.pageKey,
            ),
          ),
          GoRoute(
            path: '/calendar',
            pageBuilder: (context, state) => FadeTransitionPage(
              child: const CalendarScreen(),
              key: state.pageKey,
            ),
          ),
          GoRoute(
            path: '/mindmap',
            pageBuilder: (context, state) => FadeTransitionPage(
              child: const MindMapScreen(),
              key: state.pageKey,
            ),
          ),
          // /stats removed, replaced by / (Home) and /tasks
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => FadeTransitionPage(
              child: const ProfileScreen(),
              key: state.pageKey,
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => FadeTransitionPage(
              child: const SettingsScreen(),
              key: state.pageKey,
            ),
          ),
        ],
      ),
    ],
  );
}

class FadeTransitionPage extends CustomTransitionPage<void> {
  FadeTransitionPage({required super.child, required super.key})
    : super(
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurveTween(curve: Curves.easeOut).animate(animation),
              child: child,
            ),
      );
}
