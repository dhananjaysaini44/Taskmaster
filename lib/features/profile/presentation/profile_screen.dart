import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../shared/widgets/glass_app_bar.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../tasks/presentation/tasks_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).appTheme;
    final authState = ref.watch(authProvider);
    final tasksAsync = ref.watch(tasksProviderProvider);
    
    final user = authState.valueOrNull?.maybeMap(
      authenticated: (a) => a.user,
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: theme.background,
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
                    user?.displayName ?? 'User Name',
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
              _buildTile(theme, Icons.settings_outlined, 'Account Settings', () {}),
              _buildTile(theme, Icons.notifications_none_outlined, 'Notifications', () {}),
              _buildTile(theme, Icons.shield_outlined, 'Privacy & Security', () {}),
            ]),
            
            const SizedBox(height: 24),
            
            _buildSection(theme, 'App Preferences', [
              _buildTile(theme, Icons.palette_outlined, 'Appearance', () {}),
              _buildTile(theme, Icons.language_outlined, 'Language', () {}),
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
          child: Column(
            children: items,
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
}

