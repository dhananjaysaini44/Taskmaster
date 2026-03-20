import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme_extension.dart';

class OverviewItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final AppThemeExtension theme;

  const OverviewItem({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value.toString(),
          style: theme.titleLarge.copyWith(color: color, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.labelSmall.copyWith(color: theme.textSecondary),
        ),
      ],
    );
  }
}
