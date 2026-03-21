import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/task_model.dart';
import '../../../core/services/notification_service.dart';

import '../../auth/presentation/providers/user_id_provider.dart';

part 'task_repository.g.dart';

class TaskRepository {
  final String uid;
  final Box _box;
  final List<TaskModel> _tasks = [];
  final _controller = StreamController<List<TaskModel>>.broadcast();
  final _firestore = FirebaseFirestore.instance;

  TaskRepository({required this.uid, required this._box}) {
    _loadTasks();
    _syncWithCloud();
    _rescheduleAllNotifications();
  }

  void _rescheduleAllNotifications() {
    for (final task in _tasks) {
      if (task.status != TaskStatus.completed) {
        _scheduleTaskNotification(task);
      }
    }
  }

  Future<void> _scheduleTaskNotification(TaskModel task) async {
    final id = task.id.hashCode;
    await NotificationService().scheduleNotification(
      id: id,
      title: 'Task Reminder',
      body: 'Upcoming task: ${task.title}',
      scheduledDate: task.dueDate,
    );
  }

  Future<void> _cancelTaskNotification(String taskId) async {
    await NotificationService().cancelNotification(taskId.hashCode);
  }

  void _loadTasks() {
    final List<dynamic>? data = _box.get('items');
    if (data != null) {
      _tasks.clear();
      for (final item in data) {
        try {
          var task = TaskModel.fromJson(Map<String, dynamic>.from(item as Map));
          // Migration: If task is completed but has no completedAt, use dueDate or createdAt
          if (task.status == TaskStatus.completed && task.completedAt == null) {
            task = task.copyWith(completedAt: task.dueDate);
          }
          _tasks.add(task);
        } catch (e) {
          // Skip invalid entries
        }
      }
    }
  }

  Future<void> _syncWithCloud() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .orderBy('createdAt')
          .get();

      if (snapshot.docs.isNotEmpty) {
        final cloudTasks = snapshot.docs
            .map((doc) => TaskModel.fromJson(doc.data()))
            .toList();

        // No need for activeUid check here anymore because this instance
        // is dedicated to this uid and will be disposed if the user switches.
        _tasks.clear();
        _tasks.addAll(cloudTasks);
        await _saveTasksLocal();
        _controller.add(List.from(_tasks));
      } else if (_tasks.isNotEmpty) {
        // If cloud is empty but local has data, upload local data
        final batch = _firestore.batch();
        for (final task in _tasks) {
          final docRef = _firestore
              .collection('users')
              .doc(uid)
              .collection('tasks')
              .doc(task.id);
          batch.set(docRef, task.toJson());
        }
        await batch.commit();
      }
    } catch (e) {
      // debugPrint('Error syncing tasks with cloud: $e');
    }
  }

  Future<void> _saveTasksLocal() async {
    await _box.put('items', _tasks.map((t) => t.toJson()).toList());
  }

  Future<void> _saveTaskToCloud(TaskModel task) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(task.id)
        .set(task.toJson());
  }

  Future<void> _deleteTaskFromCloud(String id) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(id)
        .delete();
  }

  Future<void> _saveAllTasksToCloud() async {
    final batch = _firestore.batch();
    for (final task in _tasks) {
      final docRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(task.id);
      batch.set(docRef, task.toJson());
    }
    await batch.commit();
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
    String? notes,
  }) async {
    final newTask = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      priority: priority,
      colorValue: colorValue,
      status: TaskStatus.todo,
      progressPercentage: 0.0,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      notes: notes,
    );
    _tasks.add(newTask);
    await _saveTasksLocal();
    await _saveTaskToCloud(newTask);
    await _scheduleTaskNotification(newTask);
    _controller.add(List.from(_tasks));
  }

  Future<void> updateStatus(String id, TaskStatus status) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        status: status,
        completedAt: status == TaskStatus.completed ? DateTime.now() : null,
      );
      if (status == TaskStatus.completed) {
        await _cancelTaskNotification(id);
      } else {
        await _scheduleTaskNotification(_tasks[index]);
      }
      await _saveTasksLocal();
      await _saveTaskToCloud(_tasks[index]);
      _controller.add(List.from(_tasks));
    }
  }

  Future<void> updateProgress(String id, double progress) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(progressPercentage: progress);
      await _saveTasksLocal();
      await _saveTaskToCloud(_tasks[index]);
      _controller.add(List.from(_tasks));
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    await _cancelTaskNotification(id);
    await _saveTasksLocal();
    await _deleteTaskFromCloud(id);
    _controller.add(List.from(_tasks));
  }

  Future<void> reorderTasks(int oldIndex, int newIndex) async {
    // Standard Flutter ReorderableListView adjustment
    int adjustedNewIndex = newIndex;
    if (oldIndex < adjustedNewIndex) {
      adjustedNewIndex -= 1;
    }

    final task = _tasks.removeAt(oldIndex);
    _tasks.insert(adjustedNewIndex, task);

    await _saveTasksLocal();
    await _saveAllTasksToCloud(); // Reorder affects all or at least many, so resave all or updated ones.
    _controller.add(List.from(_tasks));
  }

  Future<void> updateTask(TaskModel task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      if (task.status != TaskStatus.completed) {
        await _scheduleTaskNotification(task);
      } else {
        await _cancelTaskNotification(task.id);
      }
      await _saveTasksLocal();
      await _saveTaskToCloud(task);
      _controller.add(List.from(_tasks));
    }
  }

  void dispose() {
    _controller.close();
  }
}

@riverpod
Future<TaskRepository> taskRepository(TaskRepositoryRef ref) async {
  final uid = ref.watch(userIdProvider);
  if (uid == null) {
    throw Exception('User must be authenticated to access TaskRepository');
  }

  final boxName = 'tasks_$uid';
  final box = await Hive.openBox(boxName);

  final repo = TaskRepository(uid: uid, box: box);

  ref.onDispose(() {
    repo.dispose();
    // Not closing the box here to avoid issues if other things are using it,
    // but Hive balances open/close calls.
  });

  return repo;
}
