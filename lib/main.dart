import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/presentation/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    const ProviderScope(
      child: LifeManagerApp(),
    ),
  );
}

class LifeManagerApp extends ConsumerWidget {
  const LifeManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final settingsState = ref.watch(settingsProviderProvider);

    return MaterialApp.router(
      title: 'Life Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(seedColor: settingsState.seedColor),
      darkTheme: AppTheme.darkTheme(seedColor: settingsState.seedColor),
      themeMode: settingsState.themeMode,
      routerConfig: router,
    );
  }
}
