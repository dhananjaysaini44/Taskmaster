import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../shared/widgets/glass_app_bar.dart';
import '../../tasks/presentation/tasks_provider.dart';
import '../../tasks/domain/task_model.dart';
import '../../tasks/presentation/widgets/add_task_modal.dart';
import '../../auth/presentation/auth_provider.dart';
import '../domain/home_stats.dart';
import './widgets/stat_card.dart';
import './widgets/priority_distribution_chart.dart';
import './widgets/overview_item.dart';
import './widgets/deadline_tile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only context is needed for most builders now
    return const _HomeScreenContent();
  }
}

class _HomeScreenContent extends ConsumerWidget {
  const _HomeScreenContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).appTheme;
    final authState = ref.watch(authProvider).valueOrNull;
    final user = authState?.maybeWhen(
      authenticated: (user) => user,
      orElse: () => null,
    );
    final tasksAsync = ref.watch(tasksProviderProvider);

    return Scaffold(
      backgroundColor: Colors.transparent, // Required for ambient background
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        title: _HomeAppBarTitle(user: user, theme: theme),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
            tooltip: 'Settings',
          ),
          SizedBox(width: theme.spacingSM),
        ],
      ),
      body: tasksAsync.when(
        data: (tasks) => _HomeBody(tasks: tasks, theme: theme),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _HomeBody extends ConsumerWidget {
  final List<TaskModel> tasks;
  final AppThemeExtension theme;

  const _HomeBody({required this.tasks, required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = HomeStats.fromTasks(tasks);
    final upcoming = tasks.where((t) => !t.isCompleted).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    final displayTasks = upcoming.take(3).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: theme.spacingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top +
                kToolbarHeight,
          ),
          _SummaryCards(stats: stats, theme: theme),
          SizedBox(height: theme.spacingXL),
          PriorityDistributionChart(
            theme: theme,
            high: stats.highPriority,
            medium: stats.mediumPriority,
            low: stats.lowPriority,
          ),
          SizedBox(height: theme.spacingXL),
          _CompletionOverview(stats: stats, theme: theme),
          SizedBox(height: theme.spacingXL),
          _UpcomingSection(
            displayTasks: displayTasks,
            theme: theme,
            onAddTask: () => _showAddTask(context),
            onToggle: (task) =>
                ref.read(tasksProviderProvider.notifier).toggleComplete(task),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  void _showAddTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTaskModal(),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  final HomeStats stats;
  final AppThemeExtension theme;

  const _SummaryCards({required this.stats, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Total Tasks',
            value: stats.totalTasks.toString(),
            icon: Icons.assignment_outlined,
            color: theme.primary,
            theme: theme,
          ),
        ),
        SizedBox(width: theme.spacingMD),
        Expanded(
          child: StatCard(
            title: 'Efficiency',
            value: '${stats.efficiency}%',
            icon: Icons.bolt_outlined,
            color: theme.accent,
            theme: theme,
          ),
        ),
      ],
    );
  }
}

class _CompletionOverview extends StatelessWidget {
  final HomeStats stats;
  final AppThemeExtension theme;

  const _CompletionOverview({required this.stats, required this.theme});

  @override
  Widget build(BuildContext context) {
    final pending = stats.totalTasks - stats.completedTasks;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Completion Overview',
          style: theme.titleMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: theme.spacingMD),
        Container(
          height: 150,
          padding: EdgeInsets.all(theme.spacingLG),
          decoration: BoxDecoration(
            color: theme.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(theme.radiusLG),
            border: Border.all(color: theme.primary.withValues(alpha: 0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OverviewItem(
                label: 'Completed',
                value: stats.completedTasks,
                color: theme.accent,
                theme: theme,
              ),
              OverviewItem(
                label: 'Pending',
                value: pending,
                color: theme.textHint,
                theme: theme,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UpcomingSection extends StatelessWidget {
  final List<TaskModel> displayTasks;
  final AppThemeExtension theme;
  final VoidCallback onAddTask;
  final Function(TaskModel) onToggle;

  const _UpcomingSection({
    required this.displayTasks,
    required this.theme,
    required this.onAddTask,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Deadlines',
              style: theme.titleMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: onAddTask,
              icon: Icon(Icons.add_circle_outline, color: theme.primary),
              tooltip: 'Quick Add Task',
            ),
          ],
        ),
        SizedBox(height: theme.spacingSM),
        if (displayTasks.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.all(theme.spacingXL),
              child: Text(
                'No upcoming deadlines',
                style: theme.bodyMedium.copyWith(color: theme.textHint),
              ),
            ),
          )
        else
          ...displayTasks.map((task) => DeadlineTile(
                task: task,
                theme: theme,
                onToggle: () => onToggle(task),
              )),
      ],
    );
  }
}

class _HomeAppBarTitle extends StatelessWidget {
  final dynamic user;
  final AppThemeExtension theme;
  const _HomeAppBarTitle({required this.user, required this.theme});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/profile'),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: theme.primary.withValues(alpha: 0.2),
            backgroundImage:
                user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
            child: user?.photoURL == null
                ? Icon(Icons.person, size: 20, color: theme.primary)
                : null,
          ),
          SizedBox(width: theme.spacingSM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome',
                  style: theme.labelSmall.copyWith(color: theme.textSecondary),
                ),
                Text(
                  user?.displayName ?? 'User',
                  style: theme.titleMedium.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
