import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/models/calendar_event_model.dart';

part 'events_provider.g.dart';

@riverpod
class EventsProvider extends _$EventsProvider {
  @override
  AsyncValue<List<CalendarEventModel>> build() {
    // Initial dummy data as requested (no hardcoded data in screen, but need a starting point)
    // Actually, I'll start with empty and let user add.
    return const AsyncValue.data([]);
  }

  Future<void> addEvent(CalendarEventModel event) async {
    state = const AsyncValue.loading();
    try {
      final currentEvents = state.value ?? [];
      state = AsyncValue.data([...currentEvents, event]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteEvent(String id) async {
    final currentEvents = state.value ?? [];
    state = AsyncValue.data(currentEvents.where((e) => e.id != id).toList());
  }
}
