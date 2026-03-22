import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/models/calendar_event_model.dart';

part 'calendar_repository.g.dart';

class CalendarRepository {
  final String uid;
  final Box _box;
  final _firestore = FirebaseFirestore.instance;

  // ignore: prefer_initializing_formals
  CalendarRepository({required this.uid, required Box box}) : _box = box;

  List<CalendarEventModel> loadEventsLocal() {
    final List<dynamic>? data = _box.get('items');
    if (data != null) {
      return data
          .map(
            (item) => CalendarEventModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
    }
    return [];
  }

  Future<void> saveEventsLocal(List<CalendarEventModel> events) async {
    await _box.put('items', events.map((e) => e.toJson()).toList());
  }

  Future<List<CalendarEventModel>> syncWithCloud(
    List<CalendarEventModel> localEvents,
  ) async {
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

        await saveEventsLocal(cloudEvents);
        return cloudEvents;
      } else if (localEvents.isNotEmpty) {
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
      // Error handling handled by caller or silently failed as per existing logic
    }
    return localEvents;
  }

  Future<void> saveEventToCloud(CalendarEventModel event) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('events')
        .doc(event.id)
        .set(event.toJson());
  }

  Future<void> deleteEventFromCloud(String id) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('events')
        .doc(id)
        .delete();
  }
}

@riverpod
Future<CalendarRepository> calendarRepository(CalendarRepositoryRef ref) async {
  final auth = FirebaseAuth.instance;
  final uid = auth.currentUser?.uid;
  if (uid == null) throw Exception('User not authenticated');

  final box = await Hive.openBox('events_$uid');
  return CalendarRepository(uid: uid, box: box);
}
