import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme_extension.dart';

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;
  final bool centerTitle;

  const GlassAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appTheme;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: theme.surface.withValues(alpha: 0.7),
          child: AppBar(
            title: title,
            actions: actions,
            centerTitle: centerTitle,
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
