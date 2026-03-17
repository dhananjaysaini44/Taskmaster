import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme_extension.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appTheme;

    return Scaffold(
      backgroundColor: theme.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: RadialGradientPainter(
                color: theme.primary.withValues(alpha: 0.15),
              ),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.5, end: 1.0).animate(_animation),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.auto_awesome_motion_rounded,
                      size: 80,
                      color: theme.primary,
                    ),
                    SizedBox(height: theme.spacingLG),
                    Text(
                      'Life Manager',
                      style: theme.displayLarge,
                    ),
                    SizedBox(height: theme.spacingSM),
                    Text(
                      'Let us manage your Life',
                      style: theme.titleMedium.copyWith(
                        color: theme.titleMedium.color?.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RadialGradientPainter extends CustomPainter {
  final Color color;

  RadialGradientPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color, Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
