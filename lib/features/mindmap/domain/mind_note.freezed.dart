// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mind_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MindNote _$MindNoteFromJson(Map<String, dynamic> json) {
  return _MindNote.fromJson(json);
}

/// @nodoc
mixin _$MindNote {
  String get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MindNoteCopyWith<MindNote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MindNoteCopyWith<$Res> {
  factory $MindNoteCopyWith(MindNote value, $Res Function(MindNote) then) =
      _$MindNoteCopyWithImpl<$Res, MindNote>;
  @useResult
  $Res call(
      {String id, String content, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class _$MindNoteCopyWithImpl<$Res, $Val extends MindNote>
    implements $MindNoteCopyWith<$Res> {
  _$MindNoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MindNoteImplCopyWith<$Res>
    implements $MindNoteCopyWith<$Res> {
  factory _$$MindNoteImplCopyWith(
          _$MindNoteImpl value, $Res Function(_$MindNoteImpl) then) =
      __$$MindNoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String content, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class __$$MindNoteImplCopyWithImpl<$Res>
    extends _$MindNoteCopyWithImpl<$Res, _$MindNoteImpl>
    implements _$$MindNoteImplCopyWith<$Res> {
  __$$MindNoteImplCopyWithImpl(
      _$MindNoteImpl _value, $Res Function(_$MindNoteImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$MindNoteImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MindNoteImpl implements _MindNote {
  const _$MindNoteImpl(
      {required this.id,
      required this.content,
      required this.createdAt,
      required this.updatedAt});

  factory _$MindNoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$MindNoteImplFromJson(json);

  @override
  final String id;
  @override
  final String content;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'MindNote(id: $id, content: $content, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MindNoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, content, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MindNoteImplCopyWith<_$MindNoteImpl> get copyWith =>
      __$$MindNoteImplCopyWithImpl<_$MindNoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MindNoteImplToJson(
      this,
    );
  }
}

abstract class _MindNote implements MindNote {
  const factory _MindNote(
      {required final String id,
      required final String content,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$MindNoteImpl;

  factory _MindNote.fromJson(Map<String, dynamic> json) =
      _$MindNoteImpl.fromJson;

  @override
  String get id;
  @override
  String get content;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$MindNoteImplCopyWith<_$MindNoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
