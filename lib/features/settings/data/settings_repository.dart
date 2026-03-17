import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const _themeKey = 'theme_mode';
  static const _colorKey = 'seed_color';

  Future<void> saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
  }

  Future<ThemeMode> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_themeKey);
    return ThemeMode.values.firstWhere(
      (e) => e.name == name,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> saveDefaultColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colorKey, color.toARGB32());
  }

  Future<Color?> loadDefaultColor() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(_colorKey);
    return value != null ? Color(value) : null;
  }
}
