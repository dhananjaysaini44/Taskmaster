import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/task_model.dart';

part 'task_repository.g.dart';

class TaskRepository {
  final List<TaskModel> _tasks = [];
  final _controller = StreamController<List<TaskModel>>.broadcast();

  TaskRepository() {
    _init();
  }

  void _init() {
    // Add some initial dummy tasks with varying due dates
    _tasks.addAll([
      TaskModel(
        id: '1',
        title: 'Complete Project Proposal',
        priority: TaskPriority.high,
        colorValue: 0xFF42A5F5,
        isCompleted: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TaskModel(
        id: '2',
        title: 'Design Dashboard UI',
        priority: TaskPriority.high,
        colorValue: 0xFF66BB6A,
        isCompleted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        dueDate: DateTime.now().add(const Duration(days: 1)),
      ),
      TaskModel(
        id: '3',
        title: 'Review Marketing Deck',
        priority: TaskPriority.medium,
        colorValue: 0xFFFFB74D,
        isCompleted: false,
        createdAt: DateTime.now(),
        dueDate: DateTime.now().add(const Duration(days: 2, hours: 4)),
      ),
      TaskModel(
        id: '4',
        title: 'Internal Team Meeting',
        priority: TaskPriority.low,
        colorValue: 0xFF9575CD,
        isCompleted: false,
        createdAt: DateTime.now(),
        dueDate: DateTime.now().add(const Duration(hours: 5)),
      ),
    ]);
  }

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
}


@Riverpod(keepAlive: true)
TaskRepository taskRepository(Ref ref) {
  return TaskRepository();
}
