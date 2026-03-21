import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme_extension.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appTheme;

    return Drawer(
      backgroundColor: theme.background.withValues(alpha: 0.9),
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.primary.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/logo.png',
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 64,
                      height: 64,
                      color: theme.primary.withValues(alpha: 0.2),
                      child: Icon(Icons.task_alt, color: theme.primary, size: 32),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerTile(
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/');
                  },
                  theme: theme,
                ),
                _DrawerTile(
                  icon: Icons.task_alt_outlined,
                  label: 'Tasks',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/tasks');
                  },
                  theme: theme,
                ),
                _DrawerTile(
                  icon: Icons.calendar_today_outlined,
                  label: 'Calendar',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/calendar');
                  },
                  theme: theme,
                ),
                _DrawerTile(
                  icon: Icons.hub_outlined,
                  label: 'Mind Flow',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/mindmap');
                  },
                  theme: theme,
                ),
                _DrawerTile(
                  icon: Icons.person_outline,
                  label: 'Profile',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/profile');
                  },
                  theme: theme,
                ),
                const Divider(),
                _DrawerTile(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/settings');
                  },
                  theme: theme,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'v1.8.0',
              style: theme.labelSmall.copyWith(color: theme.textHint),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final AppThemeExtension theme;

  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: theme.textSecondary),
      title: Text(
        label,
        style: theme.titleSmall.copyWith(color: theme.textPrimary),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}
