import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/utils/system_info.dart';
import '../../../shared/widgets/color_picker_widget.dart';
import '../../auth/presentation/auth_provider.dart';
import 'settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).appTheme;
    final settingsState = ref.watch(settingsProviderProvider);
    final settingsNotifier = ref.read(settingsProviderProvider.notifier);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.background,
      extendBodyBehindAppBar: true,
      body: ListView(
        padding: EdgeInsets.only(
          left: theme.spacingLG,
          right: theme.spacingLG,
          top:
              MediaQuery.of(context).padding.top +
              kToolbarHeight +
              theme.spacingMD,
          bottom: 100,
        ),
        children: [
          _buildSectionHeader(theme, 'Appearance'),
          SizedBox(height: theme.spacingMD),
          _buildThemeSelector(theme, settingsState, settingsNotifier),
          SizedBox(height: theme.spacingLG),
          _buildSectionHeader(theme, 'Brand Color'),
          SizedBox(height: theme.spacingMD),
          ColorPickerWidget(
            presets: const [
              Color(0xFF135BEC),
              Color(0xFF3B82F6),
              Color(0xFF6366F1),
              Color(0xFF8B5CF6),
              Color(0xFFD946EF),
              Color(0xFFEC4899),
              Color(0xFFEF4444),
              Color(0xFFF97316),
              Color(0xFFF59E0B),
              Color(0xFF10B981),
              Color(0xFF06B6D4),
              Color(0xFF1F2937),
            ],
            selected: settingsState.seedColor ?? theme.primary,
            onChanged: (color) => settingsNotifier.setDefaultColor(color),
          ),
          SizedBox(height: theme.spacingLG),
          _buildSectionHeader(theme, 'Preferences'),
          SizedBox(height: theme.spacingMD),
          _buildPreferenceTile(
            theme,
            Icons.notifications_none_outlined,
            'Enable Notifications',
            settingsState.notificationsEnabled,
            (value) => settingsNotifier.setNotificationsEnabled(value),
          ),
          _buildLanguageSelector(theme, settingsState, settingsNotifier),
          SizedBox(height: theme.spacingXL),
          _buildSectionHeader(theme, 'System Information'),
          SizedBox(height: theme.spacingMD),
          _buildSystemInfoCard(theme, size),
          SizedBox(height: theme.spacingXL),
          _buildAccountSection(context, ref, theme),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(AppThemeExtension theme, String title) {
    return Text(
      title.toUpperCase(),
      style: theme.labelSmall.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: theme.labelSmall.color?.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildThemeSelector(
    AppThemeExtension theme,
    SettingsState state,
    SettingsProvider notifier,
  ) {
    return SegmentedButton<ThemeMode>(
      segments: const [
        ButtonSegment(
          value: ThemeMode.light,
          label: Text('Light'),
          icon: Icon(Icons.light_mode_outlined),
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          label: Text('Dark'),
          icon: Icon(Icons.dark_mode_outlined),
        ),
        ButtonSegment(
          value: ThemeMode.system,
          label: Text('System'),
          icon: Icon(Icons.settings_brightness_outlined),
        ),
      ],
      selected: {state.themeMode},
      onSelectionChanged: (selected) => notifier.setTheme(selected.first),
      style: SegmentedButton.styleFrom(
        backgroundColor: theme.surface,
        selectedBackgroundColor: theme.primary,
        selectedForegroundColor: theme.surface,
      ),
    );
  }

  Widget _buildSystemInfoCard(AppThemeExtension theme, Size size) {
    String osName = 'Unknown';
    String osVersion = 'Unknown';

    if (kIsWeb) {
      osName = 'Web Browser';
      osVersion = 'N/A (Web)';
    } else {
      // We can use dart:io classes safely here because kIsWeb is false
      // But we need to be careful with imports.
      // Actually, it's better to use a helper or just kIsWeb check.
      try {
        osName = Platform.operatingSystem;
        osVersion = Platform.operatingSystemVersion;
      } catch (e) {
        // Ignore
      }
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.radiusLG),
        side: BorderSide(
          color:
              theme.labelSmall.color?.withValues(alpha: 0.1) ??
              Colors.transparent,
        ),
      ),
      color: theme.surface,
      child: Column(
        children: [
          _buildInfoRow(theme, 'Operating System', osName),
          _buildDivider(theme),
          _buildInfoRow(theme, 'OS Version', osVersion),
          _buildDivider(theme),
          _buildInfoRow(
            theme,
            'Screen Resolution',
            '${size.width.toInt()} x ${size.height.toInt()}',
          ),
          _buildDivider(theme),
          _buildInfoRow(theme, 'Version', '1.7.0'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(AppThemeExtension theme, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacingMD,
        vertical: theme.spacingMD,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.bodyMedium.copyWith(color: theme.labelSmall.color),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: theme.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(AppThemeExtension theme) {
    return Divider(
      height: 1,
      indent: theme.spacingMD,
      endIndent: theme.spacingMD,
      color: theme.labelSmall.color?.withValues(alpha: 0.05),
    );
  }

  Widget _buildAccountSection(
    BuildContext context,
    WidgetRef ref,
    AppThemeExtension theme,
  ) {
    return Column(
      children: [
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(theme.radiusMD),
          ),
          tileColor: theme.error.withValues(alpha: 0.05),
          leading: Icon(Icons.logout_rounded, color: theme.error),
          title: Text(
            'Sign Out',
            style: theme.bodyMedium.copyWith(
              color: theme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () async {
            await ref.read(authProvider.notifier).signOut();
            if (context.mounted) context.go('/login');
          },
        ),
      ],
    );
  }

  Widget _buildPreferenceTile(
    AppThemeExtension theme,
    IconData icon,
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.radiusLG),
        side: BorderSide(
          color:
              theme.labelSmall.color?.withValues(alpha: 0.1) ??
              Colors.transparent,
        ),
      ),
      color: theme.surface,
      child: ListTile(
        leading: Icon(icon, color: theme.primary),
        title: Text(title, style: theme.bodyMedium),
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeTrackColor: theme.primary.withValues(alpha: 0.5),
          activeThumbColor: theme.primary,
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(
    AppThemeExtension theme,
    SettingsState state,
    SettingsProvider notifier,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.radiusLG),
        side: BorderSide(
          color:
              theme.labelSmall.color?.withValues(alpha: 0.1) ??
              Colors.transparent,
        ),
      ),
      color: theme.surface,
      child: ListTile(
        leading: const Icon(Icons.language_outlined, color: Color(0xFF135BEC)),
        title: const Text('Language'),
        trailing: DropdownButton<String>(
          value: state.language,
          underline: const SizedBox(),
          onChanged: (value) {
            if (value != null) notifier.setLanguage(value);
          },
          items: const [
            DropdownMenuItem(value: 'en', child: Text('English')),
            DropdownMenuItem(value: 'es', child: Text('Spanish')),
            DropdownMenuItem(value: 'fr', child: Text('French')),
            DropdownMenuItem(value: 'hi', child: Text('Hindi')),
          ],
        ),
      ),
    );
  }
}
