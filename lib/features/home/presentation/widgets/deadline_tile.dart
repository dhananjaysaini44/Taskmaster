import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../tasks/domain/task_model.dart';

class DeadlineTile extends StatelessWidget {
  final TaskModel task;
  final AppThemeExtension theme;
  final VoidCallback onToggle;

  const DeadlineTile({
    super.key,
    required this.task,
    required this.theme,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(theme.radiusLG),
        border: Border.all(color: theme.primary.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: task.priorityColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: theme.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Due ${DateFormat('MMM dd, hh:mm a').format(task.dueDate)}',
                  style: theme.labelSmall.copyWith(color: theme.textSecondary),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
              color: task.isCompleted ? theme.accent : theme.textHint.withValues(alpha: 0.5),
            ),
            onPressed: onToggle,
          ),
        ],
      ),
    );
  }
}
