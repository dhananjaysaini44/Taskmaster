import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/mind_note_repository.dart';
import '../../domain/mind_note.dart';

part 'mind_notes_provider.g.dart';

@riverpod
class MindNotes extends _$MindNotes {
  @override
  Stream<List<MindNote>> build() {
    final repoAsync = ref.watch(mindNoteRepositoryProvider);
    return repoAsync.when(
      data: (repo) => repo.watchNotes(),
      loading: () => const Stream.empty(),
      error: (error, stack) => const Stream.empty(),
    );
  }

  Future<void> addNote(String content) async {
    final repo = await ref.read(mindNoteRepositoryProvider.future);
    await repo.addNote(content);
  }

  Future<void> updateNote(MindNote note) async {
    final repo = await ref.read(mindNoteRepositoryProvider.future);
    await repo.updateNote(note);
  }

  Future<void> deleteNote(String id) async {
    final repo = await ref.read(mindNoteRepositoryProvider.future);
    await repo.deleteNote(id);
  }
}
