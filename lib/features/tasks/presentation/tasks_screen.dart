import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../shared/widgets/glass_app_bar.dart';
import '../../auth/presentation/auth_provider.dart';
import '../domain/task_model.dart';
import 'tasks_provider.dart';
import 'widgets/task_card.dart';
import 'widgets/add_task_modal.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).appTheme;
    final tasksAsync = ref.watch(tasksProviderProvider);
    final filter = ref.watch(tasksFilterProvider);
    final authState = ref.watch(authProvider).valueOrNull;
    final user = authState?.maybeWhen(
      authenticated: (user) => user,
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: theme.background,
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        title: _TasksAppBarTitle(user: user, theme: theme),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
            tooltip: 'Settings',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight + theme.spacingMD),
          const _TaskFilterChips(),
          Expanded(
            child: tasksAsync.when(
              data: (tasks) {
                final filteredTasks = _getFilteredTasks(tasks, filter);
                if (filteredTasks.isEmpty) {
                  return _TasksEmptyState(filter: filter, theme: theme);
                }
                return _TasksList(tasks: filteredTasks);
              },
              loading: () => _TasksLoadingState(theme: theme),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: const _AddTaskFab(),
    );
  }

  List<TaskModel> _getFilteredTasks(List<TaskModel> tasks, TaskFilter filter) {
    switch (filter) {
      case TaskFilter.upcoming:
        return tasks.where((t) => !t.isCompleted).toList();
      case TaskFilter.completed:
        return tasks.where((t) => t.isCompleted).toList();
      case TaskFilter.all:
        return tasks;
    }
  }
}

class _TasksAppBarTitle extends StatelessWidget {
  final dynamic user;
  final AppThemeExtension theme;
  const _TasksAppBarTitle({required this.user, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: theme.primary.withValues(alpha: 0.2),
          backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
          child: user?.photoURL == null ? Icon(Icons.person, size: 20, color: theme.primary) : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
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
    );
  }
}

class _TaskFilterChips extends ConsumerWidget {
  const _TaskFilterChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).appTheme;
    final currentFilter = ref.watch(tasksFilterProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: theme.spacingLG, vertical: theme.spacingMD),
      child: Row(
        children: TaskFilter.values.map((filter) {
          final isSelected = currentFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter.name[0].toUpperCase() + filter.name.substring(1)),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  ref.read(tasksFilterProvider.notifier).setFilter(filter);
                }
              },
              backgroundColor: theme.surface,
              selectedColor: theme.primary.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: isSelected ? theme.primary : theme.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? theme.primary : theme.borderSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TasksList extends ConsumerStatefulWidget {
  final List<TaskModel> tasks;
  const _TasksList({required this.tasks});

  @override
  ConsumerState<_TasksList> createState() => _TasksListState();
}

class _TasksListState extends ConsumerState<_TasksList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<TaskModel> _internalList = [];

  @override
  void initState() {
    super.initState();
    _internalList.addAll(widget.tasks);
  }

  @override
  void didUpdateWidget(_TasksList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncList(widget.tasks);
  }

  void _syncList(List<TaskModel> newList) {
    for (int i = _internalList.length - 1; i >= 0; i--) {
      final oldTask = _internalList[i];
      if (!newList.any((t) => t.id == oldTask.id)) {
        final removed = _internalList.removeAt(i);
        _listKey.currentState?.removeItem(
          i,
          (context, animation) => _buildRemovedItem(removed, i, animation),
        );
      }
    }
    for (int i = 0; i < newList.length; i++) {
      final newTask = newList[i];
      final existingIndex = _internalList.indexWhere((t) => t.id == newTask.id);
      if (existingIndex == -1) {
        _internalList.insert(i, newTask);
        _listKey.currentState?.insertItem(i);
      } else {
        _internalList[existingIndex] = newTask;
      }
    }
  }

  Widget _buildRemovedItem(TaskModel task, int index, Animation<double> animation) {
    return FadeTransition(opacity: animation, child: TaskCard(task: task, index: index, onToggle: () {}, onDelete: () {}));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appTheme;
    return AnimatedList(
      key: _listKey,
      initialItemCount: _internalList.length,
      padding: EdgeInsets.only(left: theme.spacingLG, right: theme.spacingLG, bottom: 100),
      itemBuilder: (context, index, animation) {
        final task = _internalList[index];
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: TaskCard(
            task: task,
            index: index,
            onToggle: () => ref.read(tasksProviderProvider.notifier).toggleComplete(task),
            onDelete: () => ref.read(tasksProviderProvider.notifier).deleteTask(task.id),
          ),
        );
      },
    );
  }
}

class _TasksEmptyState extends StatelessWidget {
  final TaskFilter filter;
  final AppThemeExtension theme;
  const _TasksEmptyState({required this.filter, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_rounded, size: 80, color: theme.textHint.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text(
            filter == TaskFilter.all ? 'No tasks yet' : 'No ${filter.name} tasks',
            style: theme.bodyMedium.copyWith(color: theme.textHint),
          ),
        ],
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
      decoration: BoxDecoration(color: theme.surface.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(theme.radiusLG)),
      child: Row(
        children: [
          Container(width: 4, height: 80, decoration: BoxDecoration(color: theme.textHint.withValues(alpha: 0.1), borderRadius: const BorderRadius.horizontal(left: Radius.circular(4)))),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 150, height: 16, decoration: BoxDecoration(color: theme.textHint.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 8),
                Container(width: 80, height: 12, decoration: BoxDecoration(color: theme.textHint.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(4))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
