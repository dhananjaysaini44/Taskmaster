import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/calendar_event_model.dart';
import '../../data/calendar_repository.dart';
import '../../../../core/services/notification_service.dart';

part 'events_provider.g.dart';

@riverpod
class EventsProvider extends _$EventsProvider {
  @override
  FutureOr<List<CalendarEventModel>> build() async {
    final repository = await ref.watch(calendarRepositoryProvider.future);
    final localEvents = repository.loadEventsLocal();
    
    // Trigger background sync
    _syncWithCloud(repository, localEvents);
    
    return localEvents;
  }

  Future<void> _syncWithCloud(CalendarRepository repository, List<CalendarEventModel> localEvents) async {
    final cloudEvents = await repository.syncWithCloud(localEvents);
    state = AsyncValue.data(cloudEvents);
    _rescheduleAllNotifications(cloudEvents);
  }

  void _rescheduleAllNotifications(List<CalendarEventModel> events) {
    for (final event in events) {
      if (!event.isCompleted) {
        _scheduleEventNotification(event);
      }
    }
  }

  Future<void> _scheduleEventNotification(CalendarEventModel event) async {
    final id = event.id.hashCode;
    await NotificationService().scheduleNotification(
      id: id,
      title: 'Event Reminder',
      body: 'Upcoming event: ${event.title}',
      scheduledDate: event.startTime,
    );
  }

  Future<void> _cancelEventNotification(String eventId) async {
    await NotificationService().cancelNotification(eventId.hashCode);
  }

  Future<void> addEvent(CalendarEventModel event) async {
    final repository = await ref.read(calendarRepositoryProvider.future);
    final currentEvents = state.value ?? [];
    final updatedEvents = [...currentEvents, event];
    state = AsyncValue.data(updatedEvents);
    
    await repository.saveEventsLocal(updatedEvents);
    await repository.saveEventToCloud(event);
    await _scheduleEventNotification(event);
  }

  Future<void> deleteEvent(String id) async {
    final repository = await ref.read(calendarRepositoryProvider.future);
    final currentEvents = state.value ?? [];
    final updatedEvents = currentEvents.where((e) => e.id != id).toList();
    state = AsyncValue.data(updatedEvents);
    
    await _cancelEventNotification(id);
    await repository.saveEventsLocal(updatedEvents);
    await repository.deleteEventFromCloud(id);
  }

  Future<void> updateEvent(CalendarEventModel event) async {
    final repository = await ref.read(calendarRepositoryProvider.future);
    final currentEvents = state.value ?? [];
    final index = currentEvents.indexWhere((e) => e.id == event.id);
    
    if (index != -1) {
      final updatedEvents = List<CalendarEventModel>.from(currentEvents);
      updatedEvents[index] = event;
      state = AsyncValue.data(updatedEvents);
      
      if (!event.isCompleted) {
        await _scheduleEventNotification(event);
      } else {
        await _cancelEventNotification(event.id);
      }
      
      await repository.saveEventsLocal(updatedEvents);
      await repository.saveEventToCloud(event);
    }
  }

  Future<void> toggleEventCompletion(String id) async {
    final repository = await ref.read(calendarRepositoryProvider.future);
    final currentEvents = state.value ?? [];
    final index = currentEvents.indexWhere((e) => e.id == id);
    
    if (index != -1) {
      final updatedEvents = List<CalendarEventModel>.from(currentEvents);
      final newIsCompleted = !updatedEvents[index].isCompleted;
      updatedEvents[index] = updatedEvents[index].copyWith(
        isCompleted: newIsCompleted,
        completedAt: newIsCompleted ? DateTime.now() : null,
      );
      state = AsyncValue.data(updatedEvents);
      
      if (newIsCompleted) {
        await _cancelEventNotification(id);
      } else {
        await _scheduleEventNotification(updatedEvents[index]);
      }
      
      await repository.saveEventsLocal(updatedEvents);
      await repository.saveEventToCloud(updatedEvents[index]);
    }
  }
}
