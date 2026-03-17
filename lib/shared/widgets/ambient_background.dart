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

    return Container(
      width: size.width,
      height: size.height,
      color: theme.colorScheme.surface,
      child: Stack(
        children: [
          // Background Base
          Positioned.fill(
            child: Container(
              color: theme.colorScheme.surface,
            ),
          ),
          
          // Glow 1: Top Left
          Positioned(
            top: -size.height * 0.2,
            left: -size.width * 0.2,
            child: _AmbientGlow(
              size: size.width * 1.2,
              color: appTheme.ambientGlow,
            ),
          ),
          
          // Glow 2: Bottom Right
          Positioned(
            bottom: -size.height * 0.2,
            right: -size.width * 0.2,
            child: _AmbientGlow(
              size: size.width * 1.2,
              color: appTheme.ambientGlow,
            ),
          ),
          
          // Pattern Overlay
          Positioned.fill(
            child: CustomPaint(
              painter: _PatternPainter(
                color: appTheme.ambientPattern,
              ),
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
