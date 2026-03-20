import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart'; // Unnecessary
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/models/calendar_event_model.dart';

part 'events_provider.g.dart';

@riverpod
class EventsProvider extends _$EventsProvider {
  Box? _box;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  AsyncValue<List<CalendarEventModel>> build() {
    final user = _auth.currentUser;
    if (user == null) {
      return const AsyncValue.data([]);
    }

    _openBox(user.uid).then((_) {
      final localEvents = _loadEvents();
      state = AsyncValue.data(localEvents);
      
      // Trigger async sync in the background
      _syncWithCloud(user.uid, localEvents).then((cloudEvents) {
        state = AsyncValue.data(cloudEvents);
      });
    });
    
    return const AsyncValue.loading();
  }

  Future<void> _openBox(String uid) async {
    final boxName = 'events_$uid';
    if (!Hive.isBoxOpen(boxName)) {
      _box = await Hive.openBox(boxName);
    } else {
      _box = Hive.box(boxName);
    }
  }

  Future<List<CalendarEventModel>> _syncWithCloud(String uid, List<CalendarEventModel> localEvents) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('events')
          .get();

      if (snapshot.docs.isNotEmpty) {
        final cloudEvents = snapshot.docs
            .map((doc) => CalendarEventModel.fromJson(doc.data()))
            .toList();
        
        // Simple merge: cloud wins
        await _saveEventsLocal(cloudEvents);
        return cloudEvents;
      } else if (localEvents.isNotEmpty) {
        // Upload local to cloud
        final batch = _firestore.batch();
        for (final event in localEvents) {
          final docRef = _firestore
              .collection('users')
              .doc(uid)
              .collection('events')
              .doc(event.id);
          batch.set(docRef, event.toJson());
        }
        await batch.commit();
      }
    } catch (e) {
      // debugPrint('Error syncing events with cloud: $e');
    }
    return localEvents;
  }

  List<CalendarEventModel> _loadEvents() {
    if (_box == null) return [];
    final List<dynamic>? data = _box!.get('items');
    if (data != null) {
      return data
          .map((item) => CalendarEventModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    }
    return [];
  }

  Future<void> _saveEventsLocal(List<CalendarEventModel> events) async {
    if (_box == null) return;
    await _box!.put('items', events.map((e) => e.toJson()).toList());
  }

  Future<void> _saveEventToCloud(CalendarEventModel event) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('events')
          .doc(event.id)
          .set(event.toJson());
    }
  }

  Future<void> _deleteEventFromCloud(String id) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('events')
          .doc(id)
          .delete();
    }
  }

  Future<void> addEvent(CalendarEventModel event) async {
    final currentEvents = state.value ?? [];
    final updatedEvents = [...currentEvents, event];
    state = AsyncValue.data(updatedEvents);
    await _saveEventsLocal(updatedEvents);
    await _saveEventToCloud(event);
  }

  Future<void> deleteEvent(String id) async {
    final currentEvents = state.value ?? [];
    final updatedEvents = currentEvents.where((e) => e.id != id).toList();
    state = AsyncValue.data(updatedEvents);
    await _saveEventsLocal(updatedEvents);
    await _deleteEventFromCloud(id);
  }

  Future<void> updateEvent(CalendarEventModel event) async {
    final currentEvents = state.value ?? [];
    final index = currentEvents.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      final updatedEvents = List<CalendarEventModel>.from(currentEvents);
      updatedEvents[index] = event;
      state = AsyncValue.data(updatedEvents);
      await _saveEventsLocal(updatedEvents);
      await _saveEventToCloud(event);
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
      await _saveEventsLocal(updatedEvents);
      await _saveEventToCloud(updatedEvents[index]);
    }
  }
}
