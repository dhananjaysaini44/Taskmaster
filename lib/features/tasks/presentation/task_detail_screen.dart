import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../domain/task_model.dart';
import 'tasks_provider.dart';
import 'widgets/add_task_modal.dart';

class TaskDetailScreen extends ConsumerWidget {
  final TaskModel task;

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).appTheme;
    final tasksAsync = ref.watch(tasksProviderProvider);

    // Watch for updates to the specific task
    final currentTask = tasksAsync.maybeWhen(
      data: (tasks) => tasks.firstWhere(
        (t) => t.id == task.id,
        orElse: () => task,
      ),
      orElse: () => task,
    );

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: theme.primary),
            onPressed: () => _showEditModal(context, currentTask),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: theme.error),
            onPressed: () => _confirmDelete(context, ref),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, currentTask, theme),
              const SizedBox(height: 32),
              _buildInfoSection(currentTask, theme),
              const SizedBox(height: 32),
              if (currentTask.notes != null && currentTask.notes!.isNotEmpty)
                _buildNotesSection(currentTask.notes!, theme),
              const SizedBox(height: 32),
              if (currentTask.status == TaskStatus.inProgress)
                _buildProgressSection(context, ref, currentTask, theme),
              const SizedBox(height: 100), // Space for bottom actions
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildBottomActions(context, ref, currentTask, theme),
    );
  }

  Widget _buildHeader(BuildContext context, TaskModel task, AppThemeExtension theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(task.status, theme).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _getStatusColor(task.status, theme).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            _getStatusText(task.status).toUpperCase(),
            style: theme.labelSmall.copyWith(
              color: _getStatusColor(task.status, theme),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          task.title,
          style: theme.displayLarge.copyWith(
            fontSize: 32,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(TaskModel task, AppThemeExtension theme) {
    return Row(
      children: [
        _buildInfoItem(
          icon: Icons.priority_high_rounded,
          label: 'Priority',
          value: task.priority.name.toUpperCase(),
          valueColor: task.priorityColor,
          theme: theme,
        ),
        const SizedBox(width: 24),
        _buildInfoItem(
          icon: Icons.calendar_today_rounded,
          label: 'Due Date',
          value: DateFormat('MMM d, yyyy').format(task.dueDate),
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    required AppThemeExtension theme,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.borderSecondary, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: theme.textSecondary),
                const SizedBox(width: 8),
                Text(label, style: theme.labelSmall),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.titleSmall.copyWith(
                color: valueColor ?? theme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection(String notes, AppThemeExtension theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notes', style: theme.titleMedium),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.borderSecondary, width: 1),
          ),
          child: Text(
            notes,
            style: theme.bodyMedium.copyWith(height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(BuildContext context, WidgetRef ref, TaskModel task, AppThemeExtension theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Progress', style: theme.titleMedium),
            Text(
              '${(task.progressPercentage * 100).toInt()}%',
              style: theme.titleSmall.copyWith(color: theme.primary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 8,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          ),
          child: Slider(
            value: task.progressPercentage,
            onChanged: (value) {
              ref.read(tasksProviderProvider.notifier).updateProgress(task, value);
            },
            activeColor: theme.primary,
            inactiveColor: theme.primary.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context, WidgetRef ref, TaskModel task, AppThemeExtension theme) {
    final bool isCompleted = task.status == TaskStatus.completed;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: theme.borderSecondary, width: 1),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Expanded(
              child: _ActionButton(
                onPressed: () {
                  final newStatus = isCompleted ? TaskStatus.todo : TaskStatus.completed;
                  ref.read(tasksProviderProvider.notifier).updateStatus(task, newStatus);
                },
                icon: isCompleted ? Icons.restart_alt_rounded : Icons.check_circle_rounded,
                label: isCompleted ? 'Mark Active' : 'Complete Task',
                color: isCompleted ? theme.primary : theme.success,
                theme: theme,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  void _showEditModal(BuildContext context, TaskModel task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTaskModal(task: task),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).appTheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete Task', style: theme.titleLarge),
        content: Text(
          'Are you sure you want to delete this task? This action cannot be undone.',
          style: theme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: theme.labelLarge),
          ),
          TextButton(
            onPressed: () {
              ref.read(tasksProviderProvider.notifier).deleteTask(task.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to tasks screen
            },
            child: Text('Delete', style: theme.labelLarge.copyWith(color: theme.error)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(TaskStatus status, AppThemeExtension theme) {
    switch (status) {
      case TaskStatus.completed:
        return theme.success;
      case TaskStatus.inProgress:
        return theme.primary;
      case TaskStatus.todo:
        return theme.neutral;
    }
  }

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.inProgress:
        return 'Active';
      case TaskStatus.todo:
        return 'To Do';
    }
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color color;
  final AppThemeExtension theme;

  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(
                label,
                style: theme.titleSmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
