import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/task_model.dart';

part 'task_repository.g.dart';

class TaskRepository {
  final List<TaskModel> _tasks = [];
  final _controller = StreamController<List<TaskModel>>.broadcast();
  final Box _box;

  TaskRepository() : _box = Hive.box('tasks') {
    _loadTasks();
  }

  void _loadTasks() {
    final List<dynamic>? data = _box.get('items');
    if (data != null) {
      _tasks.clear();
      for (final item in data) {
        try {
          _tasks.add(TaskModel.fromJson(Map<String, dynamic>.from(item as Map)));
        } catch (e) {
          // Skip invalid entries
        }
      }
    }
  }

  Future<void> _saveTasks() async {
    await _box.put('items', _tasks.map((t) => t.toJson()).toList());
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
    await _saveTasks();
    _controller.add(List.from(_tasks));
  }

  Future<void> toggleComplete(String id, bool currentStatus) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(isCompleted: !currentStatus);
      await _saveTasks();
      _controller.add(List.from(_tasks));
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    await _saveTasks();
    _controller.add(List.from(_tasks));
  }

  Future<void> reorderTasks(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final task = _tasks.removeAt(oldIndex);
    _tasks.insert(newIndex, task);
    await _saveTasks();
    _controller.add(List.from(_tasks));
  }

  Future<void> updateTask(TaskModel task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      await _saveTasks();
      _controller.add(List.from(_tasks));
    }
  }
}


@Riverpod(keepAlive: true)
TaskRepository taskRepository(Ref ref) {
  return TaskRepository();
}
