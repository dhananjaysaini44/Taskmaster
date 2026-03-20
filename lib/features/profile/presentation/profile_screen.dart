import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../shared/widgets/glass_app_bar.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../tasks/presentation/tasks_provider.dart';
import '../../settings/presentation/settings_provider.dart';
import './widgets/edit_profile_dialog.dart';

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
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(
        title: Text('My Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: theme.spacingLG),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight + theme.spacingLG),
            
            // Profile Header
            Center(
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
            ),
            
            const SizedBox(height: 32),
            
            // Task Stats Row
            tasksAsync.when(
              data: (tasks) {
                final completed = tasks.where((t) => t.isCompleted).length;
                final pending = tasks.length - completed;
                return Row(
                  children: [
                    Expanded(child: _buildSmallStat(theme, 'Completed', completed.toString(), theme.accent)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildSmallStat(theme, 'Pending', pending.toString(), theme.primary)),
                  ],
                );
              },
              loading: () => const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
              error: (_, _) => const SizedBox.shrink(),
            ),
            
            const SizedBox(height: 32),
            
            // Settings Tiles
            _buildSection(theme, 'General Settings', [
              _buildTile(theme, Icons.settings_outlined, 'Account Settings', () {
                _showAccountInfo(context, user);
              }),
              _buildToggleTile(
                theme, 
                Icons.notifications_none_outlined, 
                'Notifications', 
                settings.notificationsEnabled,
                (value) => settingsNotifier.setNotificationsEnabled(value),
              ),
              _buildTile(theme, Icons.shield_outlined, 'Privacy & Security', () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Privacy settings coming soon!')),
                );
              }),
            ]),
            
            const SizedBox(height: 24),
            
            _buildSection(theme, 'App Preferences', [
              _buildTile(theme, Icons.palette_outlined, 'Appearance', () {
                context.push('/settings');
              }),
              _buildTile(theme, Icons.language_outlined, 'Language (${settings.language.toUpperCase()})', () {
                _showLanguagePicker(context, ref);
              }),
            ]),
            
            const SizedBox(height: 32),
            
            // Logout Button
            TextButton.icon(
              onPressed: () => ref.read(authProvider.notifier).signOut(),
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: Text(
                'Sign Out',
                style: theme.bodyLarge.copyWith(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(theme.radiusMD)),
              ),
            ),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallStat(AppThemeExtension theme, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(theme.radiusMD),
        border: Border.all(color: theme.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Text(value, style: theme.titleLarge.copyWith(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: theme.labelSmall.copyWith(color: theme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildSection(AppThemeExtension theme, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: theme.labelLarge.copyWith(color: theme.textSecondary, fontWeight: FontWeight.bold)),
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

  Widget _buildTile(AppThemeExtension theme, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: theme.primary, size: 22),
      title: Text(title, style: theme.bodyMedium),
      trailing: Icon(Icons.chevron_right, color: theme.textHint, size: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(theme.radiusLG)),
    );
  }

  Widget _buildToggleTile(AppThemeExtension theme, IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(theme.radiusXL)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: theme.textHint.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2))),
              SizedBox(height: theme.spacingLG),
              Text('Account Information', style: theme.titleLarge.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: theme.spacingXL),
              _buildInfoRow(theme, 'Name', user?.displayName ?? 'Not set'),
              _buildInfoRow(theme, 'Email', user?.email ?? 'Not set'),
              _buildInfoRow(theme, 'User ID', user?.uid ?? 'Unknown'),
              SizedBox(height: theme.spacingXL),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => EditProfileDialog(
                      currentName: user?.displayName ?? '',
                    ),
                  );
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(theme.radiusMD)),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: BorderSide(color: theme.primary.withValues(alpha: 0.5)),
                  foregroundColor: theme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(theme.radiusMD)),
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

  Widget _buildInfoRow(AppThemeExtension theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.bodyMedium.copyWith(color: theme.textSecondary)),
          Text(value, style: theme.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
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
            _buildLanguageOption(context, ref, 'English', 'en', currentLang == 'en'),
            _buildLanguageOption(context, ref, 'Spanish', 'es', currentLang == 'es'),
            _buildLanguageOption(context, ref, 'French', 'fr', currentLang == 'fr'),
            _buildLanguageOption(context, ref, 'Hindi', 'hi', currentLang == 'hi'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, WidgetRef ref, String name, String code, bool isSelected) {
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

