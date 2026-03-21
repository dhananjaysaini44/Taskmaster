import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../domain/task_model.dart';
import '../task_detail_screen.dart';
import '../tasks_provider.dart';

class TaskCard extends ConsumerWidget {
  final TaskModel task;
  final VoidCallback onDelete;
  final int index;

  const TaskCard({
    super.key,
    required this.task,
    required this.onDelete,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).appTheme;
    
    final Color priorityColor = switch (task.priority) {
      TaskPriority.high => Colors.red,
      TaskPriority.medium => Colors.blue,
      TaskPriority.low => Colors.green,
    };

    final Color statusColor = Color(task.colorValue);

    return Container(
      width: 300,
      margin: EdgeInsets.only(bottom: theme.spacingMD / 2),
      decoration: BoxDecoration(
        color: theme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.borderSecondary,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 4,
                color: statusColor,
              ),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailScreen(task: task),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CategoryBadge(
                    label: task.priority.name.toUpperCase(),
                    color: priorityColor,
                  ),
                  _TaskActions(
                    onDelete: () => _showDeleteDialog(context),
                    onStatusChange: (status) {
                      ref
                          .read(tasksProviderProvider.notifier)
                          .updateStatus(task, status);
                    },
                    currentStatus: task.status,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                task.title,
                style: theme.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  decoration: task.status == TaskStatus.completed
                      ? TextDecoration.lineThrough
                      : null,
                  color: task.status == TaskStatus.completed
                      ? theme.textHint
                      : theme.textPrimary,
                ),
              ),
              if (task.notes != null && task.notes!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  task.notes!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.bodySmall.copyWith(
                    color: theme.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 6),
              if (task.status == TaskStatus.inProgress) ...[
                _ProgressBar(
                  progress: task.progressPercentage,
                  color: priorityColor,
                ),
                const SizedBox(height: 6),
              ],
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 14,
                    color: theme.textHint,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Due ${task.dueDate.day}/${task.dueDate.month}',
                    style: theme.labelSmall.copyWith(
                      color: theme.textHint,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).appTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Task', style: Theme.of(context).appTheme.titleMedium),
        content: Text('Are you sure you want to delete this task?', style: Theme.of(context).appTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Theme.of(context).appTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _CategoryBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _TaskActions extends StatelessWidget {
  final VoidCallback onDelete;
  final Function(TaskStatus) onStatusChange;
  final TaskStatus currentStatus;

  const _TaskActions({
    required this.onDelete,
    required this.onStatusChange,
    required this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.delete_outline, size: 20),
          onPressed: onDelete,
          color: Colors.red.withValues(alpha: 0.7),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;
  final Color color;

  const _ProgressBar({required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'PROGRESS',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                color: Colors.grey,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
