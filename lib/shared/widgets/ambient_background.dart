import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_theme_extension.dart';

class AmbientBackground extends StatelessWidget {
  const AmbientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = theme.extension<AppThemeExtension>()!;
    final size = MediaQuery.of(context).size;

    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              isDark ? 'assets/bg_dark.png' : 'assets/bg_light.png',
              fit: BoxFit.cover,
            ),
          ),
          
          // Subtle Overlay for Readability
          Positioned.fill(
            child: Container(
              color: (isDark ? Colors.black : Colors.white).withOpacity(0.05),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  final double size;
  final Color color;

  const _AmbientGlow({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withOpacity(0.1),
            color.withOpacity(0.0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  final Color color;

  _PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const spacing = 40.0;
    final angle = math.pi / 4;
    
    // Draw subtle grid of diagonal lines
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height * math.tan(angle), size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_PatternPainter oldDelegate) => color != oldDelegate.color;
}
