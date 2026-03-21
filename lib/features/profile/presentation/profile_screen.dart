import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../tasks/presentation/providers/tasks_provider.dart';
import '../../settings/presentation/providers/settings_provider.dart';
import '../../home/domain/home_stats.dart';
import './widgets/edit_profile_dialog.dart';
import './widgets/profile_header.dart';
import './widgets/settings_section.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).appTheme;
    final authState = ref.watch(authProvider);
    final tasksAsync = ref.watch(tasksProviderProvider);
    final settings = ref.watch(settingsProviderProvider);
    final settingsNotifier = ref.read(settingsProviderProvider.notifier);

    final user = authState.valueOrNull?.maybeMap(
      authenticated: (a) => a.user,
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: Colors.transparent, // Required for ambient background
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: theme.spacingLG),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top +
                  kToolbarHeight -
                  (theme.spacingLG * 0.75),
            ),
            ProfileHeader(user: user, theme: theme),
            SizedBox(height: theme.spacingXL),
            tasksAsync.when(
              data: (tasks) {
                final stats = HomeStats.calculate(tasks: tasks, events: []);
                final pending = stats.totalTasks - stats.completedTasks;
                return Row(
                  children: [
                    Expanded(
                      child: _SmallStatCard(
                        theme: theme,
                        label: 'Completed',
                        value: stats.completedTasks.toString(),
                        color: theme.accent,
                      ),
                    ),
                    SizedBox(width: theme.spacingMD),
                    Expanded(
                      child: _SmallStatCard(
                        theme: theme,
                        label: 'Pending',
                        value: pending.toString(),
                        color: theme.primary,
                      ),
                    ),
                  ],
                );
              },
              loading: () => SizedBox(
                height: 80,
                child: const Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => const SizedBox.shrink(),
            ),
            SizedBox(height: theme.spacingXL),
            SettingsSection(
              theme: theme,
              title: 'General Settings',
              items: [
                SettingsTile(
                  theme: theme,
                  icon: Icons.settings_outlined,
                  title: 'Account Settings',
                  onTap: () => _showAccountInfo(context, user),
                ),
                SettingsToggleTile(
                  theme: theme,
                  icon: Icons.notifications_none_outlined,
                  title: 'Notifications',
                  value: settings.notificationsEnabled,
                  onChanged: (value) =>
                      settingsNotifier.setNotificationsEnabled(value),
                ),
                SettingsTile(
                  theme: theme,
                  icon: Icons.shield_outlined,
                  title: 'Privacy & Security',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Privacy settings coming soon!'),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: theme.spacingLG),
            SettingsSection(
              theme: theme,
              title: 'App Preferences',
              items: [
                SettingsTile(
                  theme: theme,
                  icon: Icons.palette_outlined,
                  title: 'Appearance',
                  onTap: () => context.push('/settings'),
                ),
                SettingsTile(
                  theme: theme,
                  icon: Icons.language_outlined,
                  title: 'Language (${settings.language.toUpperCase()})',
                  onTap: () => _showLanguagePicker(context, ref),
                ),
              ],
            ),
            SizedBox(height: theme.spacingXL),
            _LogoutButton(
              theme: theme,
              onPressed: () => _showSignOutConfirmation(context, ref),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _showAccountInfo(BuildContext context, dynamic user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context).appTheme;
        return Container(
          padding: EdgeInsets.all(theme.spacingLG),
          decoration: BoxDecoration(
            color: theme.background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(theme.radiusXL),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.textHint.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: theme.spacingLG),
              Text(
                'Account Information',
                style: theme.titleLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: theme.spacingXL),
              _InfoRow(
                theme: theme,
                label: 'Name',
                value: user?.displayName ?? 'Not set',
              ),
              _InfoRow(
                theme: theme,
                label: 'Email',
                value: user?.email ?? 'Not set',
              ),
              _InfoRow(
                theme: theme,
                label: 'User ID',
                value: user?.uid ?? 'Unknown',
              ),
              SizedBox(height: theme.spacingXL),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) =>
                        EditProfileDialog(currentName: user?.displayName ?? ''),
                  );
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(theme.radiusMD),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: BorderSide(color: theme.primary.withValues(alpha: 0.5)),
                  foregroundColor: theme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(theme.radiusMD),
                  ),
                ),
                child: const Text('Close'),
              ),
              SizedBox(height: theme.spacingLG),
            ],
          ),
        );
      },
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(settingsProviderProvider).language;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LanguageOption(
              context: context,
              ref: ref,
              name: 'English',
              code: 'en',
              isSelected: currentLang == 'en',
            ),
            _LanguageOption(
              context: context,
              ref: ref,
              name: 'Spanish',
              code: 'es',
              isSelected: currentLang == 'es',
            ),
            _LanguageOption(
              context: context,
              ref: ref,
              name: 'French',
              code: 'fr',
              isSelected: currentLang == 'fr',
            ),
            _LanguageOption(
              context: context,
              ref: ref,
              name: 'Hindi',
              code: 'hi',
              isSelected: currentLang == 'hi',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
  void _showSignOutConfirmation(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).appTheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(theme.radiusLG),
        ),
        title: Text(
          'Sign Out',
          style: theme.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: Colors.black54), // Ensure good visibility
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: theme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(theme.radiusMD),
              ),
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class _SmallStatCard extends StatelessWidget {
  final AppThemeExtension theme;
  final String label;
  final String value;
  final Color color;

  const _SmallStatCard({
    required this.theme,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(theme.radiusMD),
        border: Border.all(color: theme.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.titleLarge.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.labelSmall.copyWith(color: theme.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final AppThemeExtension theme;
  final String label;
  final String value;

  const _InfoRow({
    required this.theme,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.bodyMedium.copyWith(color: theme.textSecondary),
          ),
          Text(
            value,
            style: theme.bodyLarge.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final BuildContext context;
  final WidgetRef ref;
  final String name;
  final String code;
  final bool isSelected;

  const _LanguageOption({
    required this.context,
    required this.ref,
    required this.name,
    required this.code,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appTheme;
    return ListTile(
      title: Text(name),
      trailing: isSelected ? Icon(Icons.check, color: theme.primary) : null,
      onTap: () {
        ref.read(settingsProviderProvider.notifier).setLanguage(code);
        Navigator.pop(context);
      },
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final AppThemeExtension theme;
  final VoidCallback onPressed;

  const _LogoutButton({required this.theme, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.logout, color: theme.error),
      label: Text(
        'Sign Out',
        style: theme.bodyLarge.copyWith(
          color: theme.error,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        backgroundColor: theme.error.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(theme.radiusMD),
        ),
      ),
    );
  }
}
