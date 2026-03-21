// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mind_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MindNoteImpl _$$MindNoteImplFromJson(Map<String, dynamic> json) =>
    _$MindNoteImpl(
      id: json['id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MindNoteImplToJson(_$MindNoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
