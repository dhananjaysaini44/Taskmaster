import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/task_repository.dart';
import '../domain/task_model.dart';

part 'tasks_provider.g.dart';

@riverpod
class TasksProvider extends _$TasksProvider {
  @override
  Stream<List<TaskModel>> build() {
    final repoAsync = ref.watch(taskRepositoryProvider);
    return repoAsync.when(
      data: (repo) => repo.watchTasks(),
      loading: () => const Stream.empty(),
      error: (error, stack) => const Stream.empty(),
    );
  }

  Future<void> addTask({
    required String title,
    required TaskPriority priority,
    required int colorValue,
    required DateTime dueDate,
  }) async {
    final repo = await ref.read(taskRepositoryProvider.future);
    await repo.addTask(
      title: title,
      priority: priority,
      colorValue: colorValue,
      dueDate: dueDate,
    );
  }


  Future<void> updateTask(TaskModel task) async {
    final repo = await ref.read(taskRepositoryProvider.future);
    await repo.updateTask(task);
  }

  Future<void> toggleComplete(TaskModel task) async {
    final repo = await ref.read(taskRepositoryProvider.future);
    await repo.toggleComplete(task.id, task.isCompleted);
  }

  Future<void> deleteTask(String id) async {
    final repo = await ref.read(taskRepositoryProvider.future);
    await repo.deleteTask(id);
  }

  Future<void> reorderTasks(int oldIndex, int newIndex) async {
    final repo = await ref.read(taskRepositoryProvider.future);
    await repo.reorderTasks(oldIndex, newIndex);
  }
}
