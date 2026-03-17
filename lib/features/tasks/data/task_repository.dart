import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/task_model.dart';

part 'task_repository.g.dart';

class TaskRepository {
  final List<TaskModel> _tasks = [];
  final _controller = StreamController<List<TaskModel>>.broadcast();

  TaskRepository();

  Stream<List<TaskModel>> watchTasks() async* {
    yield List.from(_tasks);
    yield* _controller.stream;
  }

  Future<void> addTask({
    required String title,
    required TaskPriority priority,
    required int colorValue,
    required DateTime dueDate,
  }) async {
    final newTask = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      priority: priority,
      colorValue: colorValue,
      isCompleted: false,
      createdAt: DateTime.now(),
      dueDate: dueDate,
    );
    _tasks.add(newTask);
    _controller.add(List.from(_tasks));
  }

  Future<void> toggleComplete(String id, bool currentStatus) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(isCompleted: !currentStatus);
      _controller.add(List.from(_tasks));
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    _controller.add(List.from(_tasks));
  }

  Future<void> reorderTasks(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final task = _tasks.removeAt(oldIndex);
    _tasks.insert(newIndex, task);
    _controller.add(List.from(_tasks));
  }
}


@Riverpod(keepAlive: true)
TaskRepository taskRepository(Ref ref) {
  return TaskRepository();
}
