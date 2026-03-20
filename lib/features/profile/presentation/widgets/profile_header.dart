import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme_extension.dart';

class ProfileHeader extends StatelessWidget {
  final dynamic user;
  final AppThemeExtension theme;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: theme.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: theme.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                user?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                style: theme.titleLarge.copyWith(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user?.displayName ?? 'Taskmaster User',
            style: theme.headlineSmall.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            user?.email ?? 'user@example.com',
            style: theme.bodyMedium.copyWith(color: theme.textHint),
          ),
        ],
      ),
    );
  }
}
