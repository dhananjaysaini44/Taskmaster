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
  final Color glassEffect;
  final Color success;
  final Color warning;
  final Color neutral;
  final Color highlight;

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
  final TextStyle bodySmall;

  Color get surfaceColor => surface;
  TextStyle get displaySmall => headlineSmall;
  Color get surfaceContainer => background;

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
    required this.glassEffect,
    required this.success,
    required this.warning,
    required this.neutral,
    required this.highlight,
    required this.bodySmall,
  });

  static AppThemeExtension light() => const AppThemeExtension(
    primary: Color(0xFF6366F1), // Electric Indigo
    secondary: Color(0xFF8B5CF6), // Royal Violet
    surface: Colors.white,
    background: Color(0xFFF8FAFC), // Slate 50
    error: Color(0xFFEF4444), // Crimson Red
    accent: Color(0xFF10B981), // Emerald Green
    taskAccentDefault: Color(0xFF6366F1),
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
      color: Color(0xFF0F172A), // Slate 900
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Color(0xFF0F172A),
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Color(0xFF0F172A),
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1E293B), // Slate 800
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1E293B),
    ),
    bodyLarge: TextStyle(fontSize: 18, color: Color(0xFF1E293B)),
    bodyMedium: TextStyle(fontSize: 16, color: Color(0xFF334155)), // Slate 700
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Color(0xFF64748B), // Slate 500
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Color(0xFF64748B),
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Color(0xFF64748B),
    ),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF64748B),
    textHint: Color(0xFF94A3B8), // Slate 400
    borderSecondary: Color(0xFFE2E8F0), // Slate 200
    ambientGlow: Color(0x0D6366F1),
    ambientPattern: Color(0x05000000),
    glassEffect: Color(0x1AFFFFFF),
    success: Color(0xFF10B981),
    warning: Color(0xFFF59E0B),
    neutral: Color(0xFF64748B),
    highlight: Color(0xFFF1F5F9),
  );

  static AppThemeExtension dark() => const AppThemeExtension(
    primary: Color(0xFF818CF8), // Soft Indigo
    secondary: Color(0xFFA78BFA), // Soft Violet
    surface: Color(0xFF0F172A), // Slate 900
    background: Color(0xFF020617), // Deepest Slate
    error: Color(0xFFF87171), // Lighter Red
    accent: Color(0xFF34D399), // Soft Emerald
    taskAccentDefault: Color(0xFF818CF8),
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
      color: Color(0xFFF8FAFC), // Slate 50
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Color(0xFFF8FAFC),
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Color(0xFFF8FAFC),
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Color(0xFFE2E8F0), // Slate 200
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Color(0xFFE2E8F0),
    ),
    bodyLarge: TextStyle(fontSize: 18, color: Color(0xFFE2E8F0)),
    bodyMedium: TextStyle(fontSize: 16, color: Color(0xFFCBD5E1)), // Slate 300
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Color(0xFF94A3B8), // Slate 400
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Color(0xFF94A3B8),
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Color(0xFF94A3B8),
    ),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFF94A3B8),
    textHint: Color(0xFF64748B), // Slate 500
    borderSecondary: Color(0xFF1E293B), // Slate 800
    ambientGlow: Color(0x1A818CF8),
    ambientPattern: Color(0x08FFFFFF),
    glassEffect: Color(0x33000000),
    success: Color(0xFF34D399),
    warning: Color(0xFFFBBF24),
    neutral: Color(0xFF94A3B8),
    highlight: Color(0xFF1E293B),
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
    Color? glassEffect,
    Color? success,
    Color? warning,
    Color? neutral,
    Color? highlight,
    TextStyle? bodySmall,
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
      glassEffect: glassEffect ?? this.glassEffect,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      neutral: neutral ?? this.neutral,
      highlight: highlight ?? this.highlight,
      bodySmall: bodySmall ?? this.bodySmall,
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
      taskAccentDefault: Color.lerp(
        taskAccentDefault,
        other.taskAccentDefault,
        t,
      )!,
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
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      borderSecondary: Color.lerp(borderSecondary, other.borderSecondary, t)!,
      ambientGlow: Color.lerp(ambientGlow, other.ambientGlow, t)!,
      ambientPattern: Color.lerp(ambientPattern, other.ambientPattern, t)!,
      glassEffect: Color.lerp(glassEffect, other.glassEffect, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      neutral: Color.lerp(neutral, other.neutral, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
    );
  }
}

extension AppThemeExtensionX on ThemeData {
  AppThemeExtension get appTheme => extension<AppThemeExtension>()!;
}
