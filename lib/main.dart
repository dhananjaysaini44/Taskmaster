import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/presentation/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    const ProviderScope(
      child: TaskMasterApp(),
    ),
  );
}

class TaskMasterApp extends ConsumerWidget {
  const TaskMasterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final settingsState = ref.watch(settingsProviderProvider);

    return MaterialApp.router(
      title: 'Task Master',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(seedColor: settingsState.seedColor),
      darkTheme: AppTheme.darkTheme(seedColor: settingsState.seedColor),
      themeMode: settingsState.themeMode,
      routerConfig: router,
    );
  }
}
