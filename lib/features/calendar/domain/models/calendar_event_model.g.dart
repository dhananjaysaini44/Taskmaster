// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CalendarEventModelImpl _$$CalendarEventModelImplFromJson(
  Map<String, dynamic> json,
) => _$CalendarEventModelImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  startTime: DateTime.parse(json['startTime'] as String),
  endTime: DateTime.parse(json['endTime'] as String),
  description: json['description'] as String?,
  category: json['category'] as String? ?? 'event',
  isAllDay: json['isAllDay'] as bool? ?? false,
);

Map<String, dynamic> _$$CalendarEventModelImplToJson(
  _$CalendarEventModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'startTime': instance.startTime.toIso8601String(),
  'endTime': instance.endTime.toIso8601String(),
  'description': instance.description,
  'category': instance.category,
  'isAllDay': instance.isAllDay,
};
