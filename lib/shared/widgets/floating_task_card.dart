import 'package:flutter/material.dart';
import '../../core/theme/app_theme_extension.dart';

class FloatingTaskCard extends StatelessWidget {
  final String title;
  final String priority;
  final DateTime timestamp;
  final bool isCompleted;
  final Color accentColor;
  final VoidCallback onToggleCompletion;
  final VoidCallback onDelete;

  const FloatingTaskCard({
    super.key,
    required this.title,
    required this.priority,
    required this.timestamp,
    required this.isCompleted,
    required this.accentColor,
    required this.onToggleCompletion,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appTheme;

    return Container(
      margin: EdgeInsets.only(bottom: theme.spacingMD),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(theme.radiusMD),
        border: Border(
          left: BorderSide(
            color: accentColor,
            width: 6.0,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(theme.spacingMD),
        child: Row(
          children: [
            InkWell(
              onTap: onToggleCompletion,
              child: Icon(
                isCompleted ? Icons.check_circle : Icons.circle_outlined,
                color: isCompleted ? accentColor : theme.labelSmall.color?.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(width: theme.spacingSM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.titleMedium.copyWith(
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: theme.spacingSM,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.surface,
                          borderRadius: BorderRadius.circular(theme.radiusSM),
                        ),
                        child: Text(
                          priority,
                          style: theme.labelSmall.copyWith(color: accentColor),
                        ),
                      ),
                      SizedBox(width: theme.spacingSM),
                      Text(
                        '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                        style: theme.labelSmall.copyWith(color: theme.labelSmall.color?.withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: theme.labelSmall.color?.withValues(alpha: 0.6)),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
