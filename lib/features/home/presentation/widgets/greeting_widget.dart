import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme_extension.dart';

class GreetingWidget extends StatelessWidget {
  final String userName;
  final AppThemeExtension theme;

  const GreetingWidget({
    super.key,
    required this.userName,
    required this.theme,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    if (hour < 21) return 'Good Evening';
    return 'Good Night';
  }

  IconData _getGreetingIcon() {
    final hour = DateTime.now().hour;
    if (hour < 12) return Icons.wb_sunny_outlined;
    if (hour < 17) return Icons.wb_cloudy_outlined;
    if (hour < 21) return Icons.wb_twilight_outlined;
    return Icons.bedtime_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              _getGreetingIcon(),
              color: theme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              _getGreeting(),
              style: theme.labelLarge.copyWith(
                color: theme.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          userName,
          style: GoogleFonts.audiowide(
            textStyle: theme.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.textPrimary,
              fontSize: 28,
            ),
          ),
        ),
      ],
    );
  }
}
