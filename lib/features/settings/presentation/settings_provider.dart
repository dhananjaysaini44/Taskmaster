import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/settings_repository.dart';

class SettingsState {
  final ThemeMode themeMode;
  final Color? seedColor;

  SettingsState({
    required this.themeMode,
    this.seedColor,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    Color? seedColor,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      seedColor: seedColor ?? this.seedColor,
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
    state = state.copyWith(themeMode: mode, seedColor: color);
  }

  Future<void> setTheme(ThemeMode mode) async {
    await _repository.saveTheme(mode);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setDefaultColor(Color color) async {
    await _repository.saveDefaultColor(color);
    state = state.copyWith(seedColor: color);
  }
}

final settingsRepositoryProvider = Provider((ref) => SettingsRepository());

final settingsProviderProvider =
    StateNotifierProvider<SettingsProvider, SettingsState>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return SettingsProvider(repo);
});
