import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/mind_note.dart';
import '../../auth/presentation/providers/user_id_provider.dart';

part 'mind_note_repository.g.dart';

class MindNoteRepository {
  final String uid;
  final Box _box;
  final List<MindNote> _notes = [];
  final _controller = StreamController<List<MindNote>>.broadcast();
  final _firestore = FirebaseFirestore.instance;

  MindNoteRepository({required this.uid, required this._box}) {
    _loadNotes();
    _syncWithCloud();
  }

  void _loadNotes() {
    final List<dynamic>? data = _box.get('items');
    if (data != null) {
      _notes.clear();
      for (final item in data) {
        try {
          _notes.add(MindNote.fromJson(Map<String, dynamic>.from(item as Map)));
        } catch (e) {
          // Skip invalid entries
        }
      }
    }
  }

  Future<void> _syncWithCloud() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('mindmap')
          .orderBy('createdAt', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final cloudNotes = snapshot.docs
            .map((doc) => MindNote.fromJson(doc.data()))
            .toList();

        _notes.clear();
        _notes.addAll(cloudNotes);
        await _saveNotesLocal();
        _controller.add(List.from(_notes));
      } else if (_notes.isNotEmpty) {
        final batch = _firestore.batch();
        for (final note in _notes) {
          final docRef = _firestore
              .collection('users')
              .doc(uid)
              .collection('mindmap')
              .doc(note.id);
          batch.set(docRef, note.toJson());
        }
        await batch.commit();
      }
    } catch (e) {
      // Silently handle sync errors
    }
  }

  Future<void> _saveNotesLocal() async {
    await _box.put('items', _notes.map((n) => n.toJson()).toList());
  }

  Future<void> _saveNoteToCloud(MindNote note) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('mindmap')
        .doc(note.id)
        .set(note.toJson());
  }

  Future<void> _deleteNoteFromCloud(String id) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('mindmap')
        .doc(id)
        .delete();
  }

  Stream<List<MindNote>> watchNotes() async* {
    yield List.from(_notes);
    yield* _controller.stream;
  }

  Future<void> addNote(String content) async {
    final now = DateTime.now();
    final newNote = MindNote(
      id: now.millisecondsSinceEpoch.toString(),
      content: content,
      createdAt: now,
      updatedAt: now,
    );
    _notes.insert(0, newNote);
    await _saveNotesLocal();
    await _saveNoteToCloud(newNote);
    _controller.add(List.from(_notes));
  }

  Future<void> updateNote(MindNote note) async {
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      final updatedNote = note.copyWith(updatedAt: DateTime.now());
      _notes[index] = updatedNote;
      await _saveNotesLocal();
      await _saveNoteToCloud(updatedNote);
      _controller.add(List.from(_notes));
    }
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((n) => n.id == id);
    await _saveNotesLocal();
    await _deleteNoteFromCloud(id);
    _controller.add(List.from(_notes));
  }

  void dispose() {
    _controller.close();
  }
}

@riverpod
Future<MindNoteRepository> mindNoteRepository(MindNoteRepositoryRef ref) async {
  final uid = ref.watch(userIdProvider);
  if (uid == null) {
    throw Exception('User must be authenticated to access MindNoteRepository');
  }

  final boxName = 'mindmap_$uid';
  final box = await Hive.openBox(boxName);

  final repo = MindNoteRepository(uid: uid, box: box);

  ref.onDispose(() {
    repo.dispose();
  });

  return repo;
}
