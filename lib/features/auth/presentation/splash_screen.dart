import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/utils/system_info.dart';
import 'splash_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _progressController.forward();

    // Set splash finished after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        ref.read(splashFinishedProvider.notifier).state = true;
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appTheme;

    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: theme.spacingXL),
          child: Column(
            children: [
              const Spacer(flex: 3),
              // Center Logo & Brand
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 120,
                      width: 120,
                    ),
                    SizedBox(height: theme.spacingLG),
                    Text(
                      'Taskmaster',
                      style: theme.displayLarge.copyWith(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 3),
              // Bottom Progress & Status
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'INITIALIZING',
                              style: theme.labelSmall.copyWith(
                                letterSpacing: 1.2,
                                color: theme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            FutureBuilder<String>(
                              future: SystemInfo.getAppVersion(),
                              builder: (context, snapshot) {
                                return Text(
                                  'Version: v ${snapshot.data?.split('+').first ?? '1.6.0'}',
                                  style: theme.labelSmall.copyWith(
                                    color: theme.textSecondary.withValues(alpha: 0.5),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: _progressAnimation.value,
                          backgroundColor: theme.primary.withValues(alpha: 0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                          minHeight: 4,
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: theme.spacingXL),
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    size: 14,
                    color: theme.textSecondary.withValues(alpha: 0.3),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'SECURE CLOUD SYNC',
                    style: theme.labelSmall.copyWith(
                      fontSize: 10,
                      letterSpacing: 2,
                      color: theme.textSecondary.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
              SizedBox(height: theme.spacingMD),
            ],
          ),
        ),
      ),
    );
  }
}
