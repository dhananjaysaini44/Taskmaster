import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../shared/widgets/glass_app_bar.dart';
import '../../tasks/presentation/tasks_provider.dart';
import '../../tasks/domain/task_model.dart';
import 'package:intl/intl.dart';
import '../../tasks/presentation/widgets/add_task_modal.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).appTheme;
    final tasksAsync = ref.watch(tasksProviderProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(
        title: Text('Task Analytics'),
      ),
      body: tasksAsync.when(
        data: (tasks) => _buildBody(context, ref, theme, tasks),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, AppThemeExtension theme, List<TaskModel> tasks) {
    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final totalTasks = tasks.length;
    final efficiency = totalTasks > 0 ? (completedTasks / totalTasks * 100).toInt() : 0;
    
    // Group tasks by priority for charting
    final highPriority = tasks.where((t) => t.priority == TaskPriority.high).length;
    final mediumPriority = tasks.where((t) => t.priority == TaskPriority.medium).length;
    final lowPriority = tasks.where((t) => t.priority == TaskPriority.low).length;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: theme.spacingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight + theme.spacingMD),
          _buildSummaryCards(theme, totalTasks, efficiency),
          const SizedBox(height: 32),
          _buildPriorityDistribution(theme, highPriority, mediumPriority, lowPriority),
          const SizedBox(height: 32),
          _buildCompletionOverview(theme, completedTasks, totalTasks),
          const SizedBox(height: 32),
          _buildUpcomingDeadlines(context, ref, theme, tasks),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(AppThemeExtension theme, int total, int efficiency) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Total Tasks',
            value: total.toString(),
            icon: Icons.assignment_outlined,
            color: theme.primary,
            theme: theme,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: 'Efficiency',
            value: '$efficiency%',
            icon: Icons.bolt_outlined,
            color: theme.accent,
            theme: theme,
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityDistribution(AppThemeExtension theme, int high, int med, int low) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Priority Distribution', style: theme.titleMedium.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(theme.radiusLG),
            border: Border.all(color: theme.primary.withValues(alpha: 0.1)),
          ),
          child: PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 40,
              sections: [
                PieChartSectionData(value: high.toDouble(), color: Colors.redAccent, title: 'High', radius: 50, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                PieChartSectionData(value: med.toDouble(), color: Colors.orangeAccent, title: 'Med', radius: 50, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                PieChartSectionData(value: low.toDouble(), color: theme.primary, title: 'Low', radius: 50, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionOverview(AppThemeExtension theme, int completed, int total) {
    final pending = total - completed;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Completion Overview', style: theme.titleMedium.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          height: 150,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(theme.radiusLG),
            border: Border.all(color: theme.primary.withValues(alpha: 0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _OverviewItem(label: 'Completed', value: completed, color: theme.accent, theme: theme),
              _OverviewItem(label: 'Pending', value: pending, color: theme.textHint, theme: theme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingDeadlines(BuildContext context, WidgetRef ref, AppThemeExtension theme, List<TaskModel> tasks) {
    final upcoming = tasks.where((t) => !t.isCompleted).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    
    final displayTasks = upcoming.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Upcoming Deadlines', style: theme.titleMedium.copyWith(fontWeight: FontWeight.bold)),
            IconButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const AddTaskModal(),
              ),
              icon: Icon(Icons.add_circle_outline, color: theme.primary),
              tooltip: 'Quick Add Task',
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (displayTasks.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text('No upcoming deadlines', style: theme.bodyMedium.copyWith(color: theme.textHint)),
            ),
          )
        else
          ...displayTasks.map((task) => _DeadlineTile(
                task: task,
                theme: theme,
                onToggle: () => ref.read(tasksProviderProvider.notifier).toggleComplete(task),
              )),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final AppThemeExtension theme;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(theme.radiusLG),
        border: Border.all(color: theme.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 12),
          Text(value, style: theme.titleLarge.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: theme.labelSmall.copyWith(color: theme.textSecondary)),
        ],
      ),
    );
  }
}

class _OverviewItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final AppThemeExtension theme;

  const _OverviewItem({required this.label, required this.value, required this.color, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value.toString(), style: theme.titleLarge.copyWith(color: color, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: theme.labelSmall.copyWith(color: theme.textSecondary)),
      ],
    );
  }
}

class _DeadlineTile extends StatelessWidget {
  final TaskModel task;
  final AppThemeExtension theme;
  final VoidCallback onToggle;

  const _DeadlineTile({required this.task, required this.theme, required this.onToggle});

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
