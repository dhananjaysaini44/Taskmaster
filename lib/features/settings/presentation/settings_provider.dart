import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/settings_repository.dart';

class SettingsState {
  final ThemeMode themeMode;
  final Color? seedColor;
  final bool notificationsEnabled;
  final String language;

  SettingsState({
    required this.themeMode,
    this.seedColor,
    this.notificationsEnabled = true,
    this.language = 'en',
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    Color? seedColor,
    bool? notificationsEnabled,
    String? language,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      seedColor: seedColor ?? this.seedColor,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
    );
  }
}

class SettingsProvider extends StateNotifier<SettingsState> {
  final SettingsRepository _repository;

  SettingsProvider(this._repository)
      : super(SettingsState(themeMode: ThemeMode.system)) {
    _init();
  }

  Future<void> _init() async {
    final mode = await _repository.loadTheme();
    final color = await _repository.loadDefaultColor();
    final notifications = await _repository.loadNotificationsEnabled();
    final language = await _repository.loadLanguage();
    state = state.copyWith(
      themeMode: mode,
      seedColor: color,
      notificationsEnabled: notifications,
      language: language,
    );
  }

  Future<void> setTheme(ThemeMode mode) async {
    await _repository.saveTheme(mode);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setDefaultColor(Color color) async {
    await _repository.saveDefaultColor(color);
    state = state.copyWith(seedColor: color);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _repository.saveNotificationsEnabled(enabled);
    state = state.copyWith(notificationsEnabled: enabled);
  }

  Future<void> setLanguage(String languageCode) async {
    await _repository.saveLanguage(languageCode);
    state = state.copyWith(language: languageCode);
  }
}

final settingsRepositoryProvider = Provider((ref) => SettingsRepository());

final settingsProviderProvider =
    StateNotifierProvider<SettingsProvider, SettingsState>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return SettingsProvider(repo);
});
