import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../domain/task_model.dart';
import '../../calendar/presentation/events_provider.dart';
import '../../calendar/domain/models/calendar_event_model.dart';
import 'tasks_provider.dart';
import 'widgets/task_card.dart';
import 'widgets/add_task_modal.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).appTheme;
    final tasksAsync = ref.watch(tasksProviderProvider);
    final eventsAsync = ref.watch(eventsProviderProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: tasksAsync.when(
        data: (tasks) {
          final events = eventsAsync.valueOrNull ?? [];
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 12),
                const _TasksHeader(),
                const SizedBox(height: 16),
                _KanbanLayout(tasks: tasks),
                const SizedBox(height: 24),
                _BentoSection(tasks: tasks, events: events),
                const SizedBox(height: 60), // Space for Bottom nav and FAB
              ],
            ),
          );
        },
        loading: () => _TasksLoadingState(theme: theme),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: const _AddTaskFab(),
    );
  }
}

class _TasksHeader extends ConsumerWidget {
  const _TasksHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).appTheme;
    final tasksAsync = ref.watch(tasksProviderProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Flow",
            style: theme.displayLarge.copyWith(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          tasksAsync.when(
            data: (tasks) {
              final remaining =
                  tasks.where((t) => t.status != TaskStatus.completed).length;
              return RichText(
                text: TextSpan(
                  style: theme.bodyMedium.copyWith(color: theme.textSecondary),
                  children: [
                    const TextSpan(text: 'You have '),
                    TextSpan(
                      text: '$remaining tasks',
                      style: TextStyle(
                        color: theme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: ' remaining for the day.'),
                  ],
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (err, stack) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _KanbanLayout extends StatelessWidget {
  final List<TaskModel> tasks;
  const _KanbanLayout({required this.tasks});

  @override
  Widget build(BuildContext context) {
    final todoTasks = tasks.where((t) => t.status == TaskStatus.todo).toList();
    final activeTasks =
        tasks.where((t) => t.status == TaskStatus.inProgress).toList();
    final completedTasks =
        tasks.where((t) => t.status == TaskStatus.completed).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      physics: const BouncingScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TaskColumn(
            title: 'To Do',
            tasks: todoTasks,
            count: todoTasks.length,
            status: TaskStatus.todo,
          ),
          const SizedBox(width: 12),
          _TaskColumn(
            title: 'Active',
            tasks: activeTasks,
            count: activeTasks.length,
            isHighlight: true,
            status: TaskStatus.inProgress,
          ),
          const SizedBox(width: 12),
          _TaskColumn(
            title: 'Completed',
            tasks: completedTasks,
            count: completedTasks.length,
            opacity: 0.6,
            status: TaskStatus.completed,
          ),
        ],
      ),
    );
  }
}

class _TaskColumn extends ConsumerWidget {
  final String title;
  final List<TaskModel> tasks;
  final int count;
  final bool isHighlight;
  final double opacity;
  final TaskStatus status;

  const _TaskColumn({
    required this.title,
    required this.tasks,
    required this.count,
    required this.status,
    this.isHighlight = false,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).appTheme;

    return DragTarget<TaskModel>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        final task = details.data;
        if (task.status != status) {
          HapticFeedback.mediumImpact();
          ref.read(tasksProviderProvider.notifier).updateStatus(task, status);
        }
      },
      builder: (context, candidateData, rejectedData) {
        return Opacity(
          opacity: opacity,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 300,
            decoration: BoxDecoration(
              color: candidateData.isNotEmpty
                  ? theme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: candidateData.isNotEmpty
                  ? Border.all(color: theme.primary.withValues(alpha: 0.2), width: 2)
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: theme.titleMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isHighlight
                              ? theme.primary.withValues(alpha: 0.1)
                              : theme.surfaceContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          count.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isHighlight ? theme.primary : theme.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (tasks.isEmpty)
                  _EmptyColumnPlaceholder(theme: theme)
                else
                  ...tasks.asMap().entries.map(
                    (entry) => LongPressDraggable<TaskModel>(
                      data: entry.value,
                      onDragStarted: () =>
                          Feedback.forLongPress(context),
                      feedback: Material(
                        type: MaterialType.transparency,
                        child: Transform.scale(
                          scale: 1.05,
                          child: Transform.rotate(
                            angle: -0.02,
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: TaskCard(
                                key: ValueKey('${entry.value.id}_feedback'),
                                task: entry.value,
                                onDelete: () {},
                                index: entry.key,
                              ),
                            ),
                          ),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.2,
                        child: TaskCard(
                          key: ValueKey('${entry.value.id}_dragging'),
                          task: entry.value,
                          onDelete: () {},
                          index: entry.key,
                        ),
                      ),
                      child: TaskCard(
                        key: ValueKey(entry.value.id),
                        task: entry.value,
                        onDelete: () => ref
                            .read(tasksProviderProvider.notifier)
                            .deleteTask(entry.value.id),
                        index: entry.key,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmptyColumnPlaceholder extends StatelessWidget {
  final AppThemeExtension theme;
  const _EmptyColumnPlaceholder({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: theme.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.primary.withValues(alpha: 0.05),
          style: BorderStyle.none,
        ),
      ),
      child: Center(
        child: Text(
          'No tasks',
          style: theme.bodySmall.copyWith(color: theme.textHint),
        ),
      ),
    );
  }
}

class _BentoSection extends StatelessWidget {
  final List<TaskModel> tasks;
  final List<CalendarEventModel> events;

  const _BentoSection({required this.tasks, required this.events});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appTheme;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final last7Days = List.generate(7, (i) => today.subtract(Duration(days: 6 - i)));

    final dailyCounts = last7Days.map((day) {
      return tasks.where((t) {
        // If completed today, count it for today regardless of dueDate
        final localCompletedAt = t.completedAt?.toLocal();
        final localDueDate = t.dueDate.toLocal();
        
        final date = localCompletedAt ?? 
                    (t.status == TaskStatus.completed ? localDueDate : null);
        
        if (date == null) return false;
        
        return date.year == day.year && 
               date.month == day.month && 
               date.day == day.day;
      }).length;
    }).toList();

    final maxCount = dailyCounts.isEmpty ? 1 : dailyCounts.reduce(math.max);
    final effectiveMax = maxCount > 0 ? maxCount : 1;

    final bars = dailyCounts.asMap().entries.map((entry) {
      final isToday = entry.key == 6; // last item is today
      return _ChartBar(
        heightFactor: entry.value / effectiveMax,
        color: isToday ? Colors.white54 : Colors.white24,
        hasBorder: isToday,
      );
    }).toList();

    final totalProductivity = dailyCounts.fold<int>(0, (p, c) => p + c);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: _BentoBox(
        color: Colors.green, // Changed to Green as per context.md
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Weekly Flow',
              style: theme.displaySmall.copyWith(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: bars,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "You've completed $totalProductivity tasks this week!",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BentoBox extends StatelessWidget {
  final Color color;
  final Widget child;

  const _BentoBox({required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: color.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}


class _ChartBar extends StatelessWidget {
  final double heightFactor;
  final Color color;
  final bool hasBorder;

  const _ChartBar({
    required this.heightFactor,
    required this.color,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 80 * heightFactor,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          border: hasBorder
              ? const Border(top: BorderSide(color: Colors.white, width: 2))
              : null,
        ),
      ),
    );
  }
}

class _TasksLoadingState extends StatelessWidget {
  final AppThemeExtension theme;
  const _TasksLoadingState({required this.theme});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: theme.spacingLG),
      itemCount: 5,
      itemBuilder: (context, index) => _SkeletonCard(theme: theme),
    );
  }
}

class _AddTaskFab extends ConsumerWidget {
  const _AddTaskFab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).appTheme;
    return FloatingActionButton(
      onPressed: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const AddTaskModal(),
      ),
      backgroundColor: theme.primary,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  final AppThemeExtension theme;
  const _SkeletonCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: theme.spacingMD),
      height: 80,
      decoration: BoxDecoration(
        color: theme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(theme.radiusLG),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 80,
            decoration: BoxDecoration(
              color: theme.textHint.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 16,
                  decoration: BoxDecoration(
                    color: theme.textHint.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: theme.textHint.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
