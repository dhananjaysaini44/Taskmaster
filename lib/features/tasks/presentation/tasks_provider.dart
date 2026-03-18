import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/task_repository.dart';
import '../domain/task_model.dart';

part 'tasks_provider.g.dart';

enum TaskFilter { all, upcoming, completed }

@riverpod
class TasksFilter extends _$TasksFilter {
  @override
  TaskFilter build() => TaskFilter.all;

  void setFilter(TaskFilter filter) => state = filter;
}

@Riverpod(keepAlive: true)
class TasksProvider extends _$TasksProvider {
  @override
  Stream<List<TaskModel>> build() {
    return ref.watch(taskRepositoryProvider).watchTasks();
  }

  Future<void> addTask({
    required String title,
    required TaskPriority priority,
    required int colorValue,
    required DateTime dueDate,
  }) async {
    await ref.read(taskRepositoryProvider).addTask(
          title: title,
          priority: priority,
          colorValue: colorValue,
          dueDate: dueDate,
        );
  }


  Future<void> updateTask(TaskModel task) async {
    await ref.read(taskRepositoryProvider).updateTask(task);
  }

  Future<void> toggleComplete(TaskModel task) async {
    await ref.read(taskRepositoryProvider).toggleComplete(task.id, task.isCompleted);
  }

  Future<void> deleteTask(String id) async {
    await ref.read(taskRepositoryProvider).deleteTask(id);
  }

  Future<void> reorderTasks(int oldIndex, int newIndex) async {
    await ref.read(taskRepositoryProvider).reorderTasks(oldIndex, newIndex);
  }
}
