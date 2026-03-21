import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme_extension.dart';

class DeadlineTile extends StatelessWidget {
  final String title;
  final String? subtext;
  final DateTime date;
  final Color statusColor;
  final bool isCompleted;
  final VoidCallback onToggle;
  final AppThemeExtension theme;

  const DeadlineTile({
    super.key,
    required this.title,
    this.subtext,
    required this.date,
    required this.statusColor,
    required this.isCompleted,
    required this.onToggle,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(theme.radiusLG),
        border: Border.all(color: theme.primary.withValues(alpha: 0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(theme.radiusLG - 1),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 4,
                color: statusColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              style: theme.titleSmall.copyWith(
                                fontWeight: FontWeight.bold,
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            if (subtext != null && subtext!.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                subtext!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.bodySmall.copyWith(
                                  color: theme.textSecondary,
                                ),
                              ),
                            ],
                            const SizedBox(height: 4),
                            Text(
                              'Due ${DateFormat('MMM dd, hh:mm a').format(date)}',
                              style: theme.labelSmall.copyWith(color: theme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isCompleted ? Icons.check_circle : Icons.circle_outlined,
                          color: isCompleted
                              ? theme.accent
                              : theme.textHint.withValues(alpha: 0.5),
                        ),
                        onPressed: onToggle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
