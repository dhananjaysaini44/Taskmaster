import 'dart:ui';
import 'package:flutter/material.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color primary;
  final Color secondary;
  final Color surface;
  final Color background;
  final Color error;
  final Color accent;
  final Color taskAccentDefault;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color borderSecondary;
  final Color ambientGlow;
  final Color ambientPattern;

  final double spacingXS;
  final double spacingSM;
  final double spacingMD;
  final double spacingLG;
  final double spacingXL;

  final double radiusSM;
  final double radiusMD;
  final double radiusLG;
  final double radiusXL;

  final TextStyle displayLarge;
  final TextStyle headlineSmall;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle labelLarge;
  final TextStyle labelSmall;

  LinearGradient get primaryGradient => LinearGradient(
        colors: [primary, secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  const AppThemeExtension({
    required this.primary,
    required this.secondary,
    required this.surface,
    required this.background,
    required this.error,
    required this.accent,
    required this.taskAccentDefault,
    required this.spacingXS,
    required this.spacingSM,
    required this.spacingMD,
    required this.spacingLG,
    required this.spacingXL,
    required this.radiusSM,
    required this.radiusMD,
    required this.radiusLG,
    required this.radiusXL,
    required this.displayLarge,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.labelLarge,
    required this.labelSmall,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.borderSecondary,
    required this.ambientGlow,
    required this.ambientPattern,
  });

  static AppThemeExtension light() => const AppThemeExtension(
        primary: Color(0xFF135BEC),
        secondary: Color(0xFF3B82F6),
        surface: Colors.white,
        background: Color(0xFFF8F9FA),
        error: Color(0xFFD32F2F),
        accent: Color(0xFF10B981),
        taskAccentDefault: Color(0xFF135BEC),
        spacingXS: 4,
        spacingSM: 8,
        spacingMD: 16,
        spacingLG: 24,
        spacingXL: 32,
        radiusSM: 8,
        radiusMD: 12,
        radiusLG: 16,
        radiusXL: 24,
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1A1A),
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1A1A),
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1A1A),
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A1A),
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A1A),
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          color: Color(0xFF1A1A1A),
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: Color(0xFF1A1A1A),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF757575),
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF757575),
        ),
        textPrimary: Color(0xFF1A1A1A),
        textSecondary: Color(0xFF757575),
        textHint: Color(0xFF9E9E9E),
        borderSecondary: Color(0xFFE0E0E0),
        ambientGlow: Color(0x0D135BEC),
        ambientPattern: Color(0x05000000),
      );

  static AppThemeExtension dark() => const AppThemeExtension(
        primary: Color(0xFF3B82F6),
        secondary: Color(0xFF60A5FA),
        surface: Color(0xFF1E1E1E),
        background: Color(0xFF121212),
        error: Color(0xFFCF6679),
        accent: Color(0xFF34D399),
        taskAccentDefault: Color(0xFF3B82F6),
        spacingXS: 4,
        spacingSM: 8,
        spacingMD: 16,
        spacingLG: 24,
        spacingXL: 32,
        radiusSM: 8,
        radiusMD: 12,
        radiusLG: 16,
        radiusXL: 24,
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFFAAAAAA),
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFFAAAAAA),
        ),
        textPrimary: Colors.white,
        textSecondary: Color(0xFFAAAAAA),
        textHint: Color(0xFF757575),
        borderSecondary: Color(0xFF2C2C2C),
        ambientGlow: Color(0x1A3B82F6),
        ambientPattern: Color(0x08FFFFFF),
      );

  @override
  AppThemeExtension copyWith({
    Color? primary,
    Color? secondary,
    Color? surface,
    Color? background,
    Color? error,
    Color? accent,
    Color? taskAccentDefault,
    double? spacingXS,
    double? spacingSM,
    double? spacingMD,
    double? spacingLG,
    double? spacingXL,
    double? radiusSM,
    double? radiusMD,
    double? radiusLG,
    double? radiusXL,
    TextStyle? displayLarge,
    TextStyle? headlineSmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? labelLarge,
    TextStyle? labelSmall,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? borderSecondary,
    Color? ambientGlow,
    Color? ambientPattern,
  }) {
    return AppThemeExtension(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      surface: surface ?? this.surface,
      background: background ?? this.background,
      error: error ?? this.error,
      accent: accent ?? this.accent,
      taskAccentDefault: taskAccentDefault ?? this.taskAccentDefault,
      spacingXS: spacingXS ?? this.spacingXS,
      spacingSM: spacingSM ?? this.spacingSM,
      spacingMD: spacingMD ?? this.spacingMD,
      spacingLG: spacingLG ?? this.spacingLG,
      spacingXL: spacingXL ?? this.spacingXL,
      radiusSM: radiusSM ?? this.radiusSM,
      radiusMD: radiusMD ?? this.radiusMD,
      radiusLG: radiusLG ?? this.radiusLG,
      radiusXL: radiusXL ?? this.radiusXL,
      displayLarge: displayLarge ?? this.displayLarge,
      headlineSmall: headlineSmall ?? this.headlineSmall,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      titleSmall: titleSmall ?? this.titleSmall,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      labelLarge: labelLarge ?? this.labelLarge,
      labelSmall: labelSmall ?? this.labelSmall,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      borderSecondary: borderSecondary ?? this.borderSecondary,
      ambientGlow: ambientGlow ?? this.ambientGlow,
      ambientPattern: ambientPattern ?? this.ambientPattern,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      background: Color.lerp(background, other.background, t)!,
      error: Color.lerp(error, other.error, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      taskAccentDefault: Color.lerp(taskAccentDefault, other.taskAccentDefault, t)!,
      spacingXS: lerpDouble(spacingXS, other.spacingXS, t)!,
      spacingSM: lerpDouble(spacingSM, other.spacingSM, t)!,
      spacingMD: lerpDouble(spacingMD, other.spacingMD, t)!,
      spacingLG: lerpDouble(spacingLG, other.spacingLG, t)!,
      spacingXL: lerpDouble(spacingXL, other.spacingXL, t)!,
      radiusSM: lerpDouble(radiusSM, other.radiusSM, t)!,
      radiusMD: lerpDouble(radiusMD, other.radiusMD, t)!,
      radiusLG: lerpDouble(radiusLG, other.radiusLG, t)!,
      radiusXL: lerpDouble(radiusXL, other.radiusXL, t)!,
      displayLarge: TextStyle.lerp(displayLarge, other.displayLarge, t)!,
      headlineSmall: TextStyle.lerp(headlineSmall, other.headlineSmall, t)!,
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t)!,
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t)!,
      titleSmall: TextStyle.lerp(titleSmall, other.titleSmall, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      labelLarge: TextStyle.lerp(labelLarge, other.labelLarge, t)!,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      borderSecondary: Color.lerp(borderSecondary, other.borderSecondary, t)!,
      ambientGlow: Color.lerp(ambientGlow, other.ambientGlow, t)!,
      ambientPattern: Color.lerp(ambientPattern, other.ambientPattern, t)!,
    );
  }
}

extension AppThemeExtensionX on ThemeData {
  AppThemeExtension get appTheme => extension<AppThemeExtension>()!;
}
