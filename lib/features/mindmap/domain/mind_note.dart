import 'package:freezed_annotation/freezed_annotation.dart';

part 'mind_note.freezed.dart';
part 'mind_note.g.dart';

@freezed
class MindNote with _$MindNote {
  const factory MindNote({
    required String id,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MindNote;

  factory MindNote.fromJson(Map<String, dynamic> json) =>
      _$MindNoteFromJson(json);
}
