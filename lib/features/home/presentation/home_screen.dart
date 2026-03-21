import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../tasks/presentation/tasks_provider.dart';
import '../../tasks/domain/task_model.dart';
import '../../calendar/domain/models/calendar_event_model.dart';
import '../../calendar/presentation/events_provider.dart';
import '../../tasks/presentation/widgets/add_task_modal.dart';
import '../../auth/presentation/auth_provider.dart';
import '../domain/home_stats.dart';
import './widgets/greeting_widget.dart';
import './widgets/task_completion_chart.dart';
import './widgets/productivity_chart.dart';
import './widgets/deadline_tile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    final eventsAsync = ref.watch(eventsProviderProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: tasksAsync.when(
        data: (tasks) => eventsAsync.when(
          data: (events) => _HomeBody(
            tasks: tasks,
            events: events,
            theme: theme,
            user: user,
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error loading events: $error')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error loading tasks: $error')),
      ),
    );
  }
}

class _HomeBody extends ConsumerWidget {
  final List<TaskModel> tasks;
  final List<CalendarEventModel> events;
  final AppThemeExtension theme;
  final dynamic user;

  const _HomeBody({
    required this.tasks,
    required this.events,
    required this.theme,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = HomeStats.calculate(tasks: tasks, events: events);

    // Combine tasks and events into a single upcoming list
    final upcomingTasks = tasks
        .where((t) => t.status != TaskStatus.completed)
        .map((task) => _DeadlineItem(
              title: task.title,
              subtext: task.notes,
              date: task.dueDate,
              statusColor: Color(task.colorValue),
              isCompleted: false,
              onToggle: () =>
                  ref.read(tasksProviderProvider.notifier).updateStatus(
                        task,
                        TaskStatus.completed,
                      ),
            ));

    final upcomingEvents = events
        .where((e) => !e.isCompleted)
        .map((event) => _DeadlineItem(
              title: event.title,
              subtext: event.category,
              date: event.startTime,
              statusColor: event.colorValue != null
                  ? Color(event.colorValue!)
                  : theme.secondary,
              isCompleted: false,
              onToggle: () {
                ref
                    .read(eventsProviderProvider.notifier)
                    .toggleEventCompletion(event.id);
              },
            ));

    final combinedUpcoming = [...upcomingTasks, ...upcomingEvents]
      ..sort((a, b) => a.date.compareTo(b.date));

    final displayItems = combinedUpcoming.take(10).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: theme.spacingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: theme.spacingSM * 2.2),
          GreetingWidget(
            userName: user?.displayName ?? 'User',
            theme: theme,
          ),
          SizedBox(height: theme.spacingMD),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              final charts = [
                SizedBox(
                  height: 180,
                  child: TaskCompletionChart(
                    theme: theme,
                    completed: stats.completedTasks,
                    pending: stats.totalTasks - stats.completedTasks,
                  ),
                ),
                SizedBox(height: theme.spacingMD),
                SizedBox(
                  height: 180,
                  child: ProductivityChart(
                    theme: theme,
                    dailyCompletions: stats.dailyProductivity,
                  ),
                ),
              ];

              if (isWide) {
                return Row(
                  children: [
                    Expanded(child: charts[0]),
                    SizedBox(width: theme.spacingMD),
                    Expanded(child: charts[2]), // items[1] is spacing
                  ],
                );
              } else {
                return Column(children: charts);
              }
            },
          ),
          SizedBox(height: theme.spacingMD),
          _UpcomingSection(
            displayItems: displayItems,
            theme: theme,
            onAddTask: () => _showAddTask(context),
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

class _DeadlineItem {
  final String title;
  final String? subtext;
  final DateTime date;
  final Color statusColor;
  final bool isCompleted;
  final VoidCallback onToggle;

  _DeadlineItem({
    required this.title,
    this.subtext,
    required this.date,
    required this.statusColor,
    required this.isCompleted,
    required this.onToggle,
  });
}

class _UpcomingSection extends StatelessWidget {
  final List<_DeadlineItem> displayItems;
  final AppThemeExtension theme;
  final VoidCallback onAddTask;

  const _UpcomingSection({
    required this.displayItems,
    required this.theme,
    required this.onAddTask,
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
        if (displayItems.isEmpty)
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
          ...displayItems.map(
            (item) => DeadlineTile(
              title: item.title,
              subtext: item.subtext,
              date: item.date,
              statusColor: item.statusColor,
              isCompleted: item.isCompleted,
              onToggle: item.onToggle,
              theme: theme,
            ),
          ),
      ],
    );
  }
}
