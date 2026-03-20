import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme_extension.dart';

class SettingsSection extends StatelessWidget {
  final AppThemeExtension theme;
  final String title;
  final List<Widget> items;

  const SettingsSection({
    super.key,
    required this.theme,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: theme.labelLarge.copyWith(
              color: theme.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(theme.radiusLG),
            border: Border.all(color: theme.primary.withValues(alpha: 0.05)),
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: items,
            ),
          ),
        ),
      ],
    );
  }
}

class SettingsTile extends StatelessWidget {
  final AppThemeExtension theme;
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;

  const SettingsTile({
    super.key,
    required this.theme,
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: theme.primary, size: 22),
      title: Text(title, style: theme.bodyMedium),
      trailing: trailing ?? Icon(Icons.chevron_right, color: theme.textHint, size: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(theme.radiusLG)),
    );
  }
}

class SettingsToggleTile extends StatelessWidget {
  final AppThemeExtension theme;
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggleTile({
    super.key,
    required this.theme,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: theme.primary, size: 22),
      title: Text(title, style: theme.bodyMedium),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeTrackColor: theme.primary.withValues(alpha: 0.5),
        activeThumbColor: theme.primary,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(theme.radiusLG)),
    );
  }
}
