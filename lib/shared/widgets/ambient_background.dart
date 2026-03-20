import 'package:flutter/material.dart';

class AmbientBackground extends StatelessWidget {
  const AmbientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
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
              color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.05),
            ),
          ),
        ],
      ),
    );
  }
}

