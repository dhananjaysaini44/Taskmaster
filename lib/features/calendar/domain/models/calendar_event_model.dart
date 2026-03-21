import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_event_model.freezed.dart';
part 'calendar_event_model.g.dart';

@freezed
class CalendarEventModel with _$CalendarEventModel {
  const factory CalendarEventModel({
    required String id,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    String? description,
    @Default('event') String category, // e.g., 'meeting', 'gym', 'work'
    @Default(false) bool isAllDay,
    @Default(false) bool isCompleted,
    DateTime? completedAt,
    int? colorValue,
    String? notes,
  }) = _CalendarEventModel;

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventModelFromJson(json);
}
