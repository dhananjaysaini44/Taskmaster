import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

enum TaskPriority { high, medium, low }

enum TaskStatus { todo, inProgress, completed }

@freezed
class TaskModel with _$TaskModel {
  const factory TaskModel({
    required String id,
    required String title,
    @Default(TaskPriority.medium) TaskPriority priority,
    @Default(0xFF42A5F5) int colorValue,
    @Default(TaskStatus.todo) TaskStatus status,
    @Default(0.0) double progressPercentage,
    required DateTime createdAt,
    required DateTime dueDate,
    DateTime? completedAt,
    String? notes,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  const TaskModel._();

  Color get priorityColor {
    switch (priority) {
      case TaskPriority.high:
        return Colors.redAccent;
      case TaskPriority.medium:
        return Colors.orangeAccent;
      case TaskPriority.low:
        return const Color(0xFF42A5F5);
    }
  }
}
