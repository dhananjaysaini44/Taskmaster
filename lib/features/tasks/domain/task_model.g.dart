// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskModelImpl _$$TaskModelImplFromJson(Map<String, dynamic> json) =>
    _$TaskModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      priority: $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']) ??
          TaskPriority.medium,
      colorValue: (json['colorValue'] as num?)?.toInt() ?? 0xFF42A5F5,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
    );

Map<String, dynamic> _$$TaskModelImplToJson(_$TaskModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'priority': _$TaskPriorityEnumMap[instance.priority]!,
      'colorValue': instance.colorValue,
      'isCompleted': instance.isCompleted,
      'createdAt': instance.createdAt.toIso8601String(),
      'dueDate': instance.dueDate.toIso8601String(),
    };

const _$TaskPriorityEnumMap = {
  TaskPriority.high: 'high',
  TaskPriority.medium: 'medium',
  TaskPriority.low: 'low',
};
