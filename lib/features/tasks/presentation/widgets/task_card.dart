import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../domain/task_model.dart';

class TaskCard extends ConsumerStatefulWidget {
  final TaskModel task;
  final int index;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.index,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  ConsumerState<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends ConsumerState<TaskCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));

    final start = widget.index * 0.06;
    final end = (start + 0.4).clamp(0.0, 1.0);

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Interval(start, end, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Interval(start, end, curve: Curves.easeOut),
    ));

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appTheme;
    final accentColor = Color(widget.task.colorValue);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Draggable<TaskModel>(
          data: widget.task,
          feedback: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - (theme.spacingLG * 2),
              child: _TaskCardContent(
                task: widget.task,
                accentColor: accentColor,
                onToggle: () {},
                onDelete: () {},
                isFeedback: true,
              ),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: _TaskCardContent(
              task: widget.task,
              accentColor: accentColor,
              onToggle: () {},
              onDelete: () {},
            ),
          ),
          child: Dismissible(
            key: Key('dismiss_${widget.task.id}'),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => widget.onDelete(),
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: theme.spacingLG),
              decoration: BoxDecoration(
                color: theme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(theme.radiusLG),
              ),
              child: Icon(Icons.delete_outline, color: theme.error),
            ),
            child: _TaskCardContent(
              task: widget.task,
              accentColor: accentColor,
              onToggle: widget.onToggle,
              onDelete: widget.onDelete,
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskCardContent extends StatelessWidget {
  final TaskModel task;
  final Color accentColor;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final bool isFeedback;

  const _TaskCardContent({
    required this.task,
    required this.accentColor,
    required this.onToggle,
    required this.onDelete,
    this.isFeedback = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appTheme;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: task.isCompleted ? 0.4 : 1.0,
      child: Card(
        elevation: isFeedback ? 12 : 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(theme.radiusLG),
        ),
        clipBehavior: Clip.antiAlias,
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
                _buildCheckmark(theme),
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
                      _buildMetaInfo(theme),
                    ],
                  ),
                ),
                if (!isFeedback)
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: theme.textHint,
                    ),
                    onPressed: onDelete,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckmark(AppThemeExtension theme) {
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

  Widget _buildMetaInfo(AppThemeExtension theme) {
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
