import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/models/calendar_event_model.dart';

part 'events_provider.g.dart';

@riverpod
class EventsProvider extends _$EventsProvider {
  late final Box _box;

  @override
  AsyncValue<List<CalendarEventModel>> build() {
    _box = Hive.box('events');
    return AsyncValue.data(_loadEvents());
  }

  List<CalendarEventModel> _loadEvents() {
    final List<dynamic>? data = _box.get('items');
    if (data != null) {
      return data
          .map((item) => CalendarEventModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    }
    return [];
  }

  Future<void> _saveEvents(List<CalendarEventModel> events) async {
    await _box.put('items', events.map((e) => e.toJson()).toList());
  }

  Future<void> addEvent(CalendarEventModel event) async {
    final currentEvents = state.value ?? [];
    final updatedEvents = [...currentEvents, event];
    state = AsyncValue.data(updatedEvents);
    await _saveEvents(updatedEvents);
  }

  Future<void> deleteEvent(String id) async {
    final currentEvents = state.value ?? [];
    final updatedEvents = currentEvents.where((e) => e.id != id).toList();
    state = AsyncValue.data(updatedEvents);
    await _saveEvents(updatedEvents);
  }

  Future<void> updateEvent(CalendarEventModel event) async {
    final currentEvents = state.value ?? [];
    final index = currentEvents.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      final updatedEvents = List<CalendarEventModel>.from(currentEvents);
      updatedEvents[index] = event;
      state = AsyncValue.data(updatedEvents);
      await _saveEvents(updatedEvents);
    }
  }

  Future<void> toggleEventCompletion(String id) async {
    final currentEvents = state.value ?? [];
    final index = currentEvents.indexWhere((e) => e.id == id);
    if (index != -1) {
      final updatedEvents = List<CalendarEventModel>.from(currentEvents);
      updatedEvents[index] = updatedEvents[index].copyWith(
        isCompleted: !updatedEvents[index].isCompleted,
      );
      state = AsyncValue.data(updatedEvents);
      await _saveEvents(updatedEvents);
    }
  }
}
