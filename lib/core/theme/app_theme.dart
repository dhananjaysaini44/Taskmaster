import 'package:flutter/material.dart';
import 'app_theme_extension.dart';

class AppTheme {
  static ThemeData lightTheme({Color? seedColor}) {
    final baseExtension = AppThemeExtension.light();
    final themeExtension = seedColor != null
        ? baseExtension.copyWith(
            primary: seedColor,
            taskAccentDefault: seedColor,
          )
        : baseExtension;

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: themeExtension.primary,
        primary: themeExtension.primary,
        secondary: themeExtension.secondary,
        surface: themeExtension.surface,
        error: themeExtension.error,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: themeExtension.background,
      extensions: [themeExtension],
    );
  }

  static ThemeData darkTheme({Color? seedColor}) {
    final baseExtension = AppThemeExtension.dark();
    final themeExtension = seedColor != null
        ? baseExtension.copyWith(
            primary: seedColor,
            taskAccentDefault: seedColor,
          )
        : baseExtension;

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: themeExtension.primary,
        primary: themeExtension.primary,
        secondary: themeExtension.secondary,
        surface: themeExtension.surface,
        error: themeExtension.error,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: themeExtension.background,
      extensions: [themeExtension],
    );
  }
}
