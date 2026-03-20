import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/task_model.dart';

part 'task_repository.g.dart';

class TaskRepository {
  final List<TaskModel> _tasks = [];
  final _controller = StreamController<List<TaskModel>>.broadcast();
  Box? _box;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  StreamSubscription? _userSubscription;

  TaskRepository() {
    _setupAuthListener();
    _initForCurrentUser();
  }

  Future<void> _initForCurrentUser() async {
    _clearState();
    final user = _auth.currentUser;
    if (user != null) {
      await _openBox(user.uid);
      _loadTasks();
      _syncWithCloud(user.uid);
    }
  }

  void _clearState() {
    _tasks.clear();
    _box = null;
    _controller.add([]);
  }

  Future<void> _openBox(String uid) async {
    final boxName = 'tasks_$uid';
    if (!Hive.isBoxOpen(boxName)) {
      _box = await Hive.openBox(boxName);
    } else {
      _box = Hive.box(boxName);
    }
  }

  void _setupAuthListener() {
    _userSubscription = _auth.authStateChanges().listen((user) async {
      _clearState();
      if (user != null) {
        await _openBox(user.uid);
        _loadTasks();
        _syncWithCloud(user.uid);
      }
    });
  }

  Future<void> _syncWithCloud(String uid) async {
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
        
        // Simple merge: cloud wins for now if there are any
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

  void _loadTasks() {
    if (_box == null) return;
    final List<dynamic>? data = _box!.get('items');
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

  Future<void> _saveTasksLocal() async {
    if (_box == null) return;
    await _box!.put('items', _tasks.map((t) => t.toJson()).toList());
  }

  Future<void> _saveTaskToCloud(TaskModel task) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .doc(task.id)
          .set(task.toJson());
    }
  }

  Future<void> _deleteTaskFromCloud(String id) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .doc(id)
          .delete();
    }
  }

  Future<void> _saveAllTasksToCloud() async {
    final user = _auth.currentUser;
    if (user != null) {
      final batch = _firestore.batch();
      // First clear existing? Or just overwrite. Overwrite is safer for maps.
      for (final task in _tasks) {
        final docRef = _firestore
            .collection('users')
            .doc(user.uid)
            .collection('tasks')
            .doc(task.id);
        batch.set(docRef, task.toJson());
      }
      await batch.commit();
    }
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
    await _saveTasksLocal();
    await _saveTaskToCloud(newTask);
    _controller.add(List.from(_tasks));
  }

  Future<void> toggleComplete(String id, bool currentStatus) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(isCompleted: !currentStatus);
      await _saveTasksLocal();
      await _saveTaskToCloud(_tasks[index]);
      _controller.add(List.from(_tasks));
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
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
      await _saveTasksLocal();
      await _saveTaskToCloud(task);
      _controller.add(List.from(_tasks));
    }
  }

  void dispose() {
    _userSubscription?.cancel();
    _controller.close();
  }
}


@Riverpod(keepAlive: true)
TaskRepository taskRepository(Ref ref) {
  return TaskRepository();
}
