import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/domain/app_user.dart';
import 'features/settings/presentation/settings_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(AppUserAdapter()); // Register the generated adapter
  await Hive.openBox('tasks');
  await Hive.openBox('events');
  await Hive.openBox('authBox'); // For session persistence

  runApp(const ProviderScope(child: TaskMasterApp()));
}

class TaskMasterApp extends ConsumerWidget {
  const TaskMasterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final settingsState = ref.watch(settingsProviderProvider);

    return MaterialApp.router(
      title: 'Taskmaster',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(seedColor: settingsState.seedColor),
      darkTheme: AppTheme.darkTheme(seedColor: settingsState.seedColor),
      themeMode: settingsState.themeMode,
      routerConfig: router,
    );
  }
}
