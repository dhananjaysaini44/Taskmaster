import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../domain/task_model.dart';

class TaskCard extends ConsumerStatefulWidget {
  final TaskModel task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  ConsumerState<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends ConsumerState<TaskCard> {

  @override
  Widget build(BuildContext context) {
    return _TaskCardContent(
      task: widget.task,
      onToggle: widget.onToggle,
      onDelete: widget.onDelete,
    );
  }
}

class _TaskCardContent extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;


  const _TaskCardContent({
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appTheme;
    final accentColor = Color(task.colorValue);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: task.isCompleted ? 0.4 : 1.0,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(theme.radiusLG),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onLongPress: () => _showDeleteDialog(context),
          child: Container(
            decoration: BoxDecoration(
              color: Color.alphaBlend(
                accentColor.withValues(alpha: 0.07),
                theme.surface,
              ),
              border: Border(
                left: BorderSide(color: accentColor, width: 4),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(theme.spacingMD),
              child: Row(
                children: [
                  _buildCheckmark(theme, accentColor),
                  SizedBox(width: theme.spacingMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: theme.titleMedium.copyWith(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            fontWeight: FontWeight.w600,
                          ),
                          child: Text(task.title),
                        ),
                        const SizedBox(height: 4),
                        _buildMetaInfo(theme, accentColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckmark(AppThemeExtension theme, Color accentColor) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: task.isCompleted
                ? accentColor
                : theme.textHint.withValues(alpha: 0.5),
            width: 2,
          ),
          color: task.isCompleted ? accentColor : Colors.transparent,
        ),
        child: task.isCompleted
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildMetaInfo(AppThemeExtension theme, Color accentColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(theme.radiusSM),
          ),
          child: Text(
            task.priority.name.toUpperCase(),
            style: theme.labelSmall.copyWith(
              color: accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
        SizedBox(width: theme.spacingSM),
        Text(
          '${task.createdAt.hour}:${task.createdAt.minute.toString().padLeft(2, '0')}',
          style: theme.labelSmall.copyWith(
            color: theme.textHint,
          ),
        ),
      ],
    );
  }
}
