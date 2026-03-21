import 'package:flutter/material.dart';
import '../../core/theme/app_theme_extension.dart';

class MinimalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget title;
  final List<Widget>? actions;
  final bool centerTitle;

  const MinimalAppBar({
    super.key,
    this.leading,
    required this.title,
    this.actions,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appTheme;

    return AppBar(
      leading: leading,
      title: title,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: theme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      shape: Border(
        bottom: BorderSide(
          color: theme.borderSecondary,
          width: 1,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
