// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CalendarEventModel _$CalendarEventModelFromJson(Map<String, dynamic> json) {
  return _CalendarEventModel.fromJson(json);
}

/// @nodoc
mixin _$CalendarEventModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get category =>
      throw _privateConstructorUsedError; // e.g., 'meeting', 'gym', 'work'
  bool get isAllDay => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  int? get colorValue => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CalendarEventModelCopyWith<CalendarEventModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarEventModelCopyWith<$Res> {
  factory $CalendarEventModelCopyWith(
          CalendarEventModel value, $Res Function(CalendarEventModel) then) =
      _$CalendarEventModelCopyWithImpl<$Res, CalendarEventModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      DateTime startTime,
      DateTime endTime,
      String? description,
      String category,
      bool isAllDay,
      bool isCompleted,
      int? colorValue});
}

/// @nodoc
class _$CalendarEventModelCopyWithImpl<$Res, $Val extends CalendarEventModel>
    implements $CalendarEventModelCopyWith<$Res> {
  _$CalendarEventModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? description = freezed,
    Object? category = null,
    Object? isAllDay = null,
    Object? isCompleted = null,
    Object? colorValue = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      isAllDay: null == isAllDay
          ? _value.isAllDay
          : isAllDay // ignore: cast_nullable_to_non_nullable
              as bool,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      colorValue: freezed == colorValue
          ? _value.colorValue
          : colorValue // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CalendarEventModelImplCopyWith<$Res>
    implements $CalendarEventModelCopyWith<$Res> {
  factory _$$CalendarEventModelImplCopyWith(_$CalendarEventModelImpl value,
          $Res Function(_$CalendarEventModelImpl) then) =
      __$$CalendarEventModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      DateTime startTime,
      DateTime endTime,
      String? description,
      String category,
      bool isAllDay,
      bool isCompleted,
      int? colorValue});
}

/// @nodoc
class __$$CalendarEventModelImplCopyWithImpl<$Res>
    extends _$CalendarEventModelCopyWithImpl<$Res, _$CalendarEventModelImpl>
    implements _$$CalendarEventModelImplCopyWith<$Res> {
  __$$CalendarEventModelImplCopyWithImpl(_$CalendarEventModelImpl _value,
      $Res Function(_$CalendarEventModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? description = freezed,
    Object? category = null,
    Object? isAllDay = null,
    Object? isCompleted = null,
    Object? colorValue = freezed,
  }) {
    return _then(_$CalendarEventModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      isAllDay: null == isAllDay
          ? _value.isAllDay
          : isAllDay // ignore: cast_nullable_to_non_nullable
              as bool,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      colorValue: freezed == colorValue
          ? _value.colorValue
          : colorValue // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CalendarEventModelImpl implements _CalendarEventModel {
  const _$CalendarEventModelImpl(
      {required this.id,
      required this.title,
      required this.startTime,
      required this.endTime,
      this.description,
      this.category = 'event',
      this.isAllDay = false,
      this.isCompleted = false,
      this.colorValue});

  factory _$CalendarEventModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CalendarEventModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final String? description;
  @override
  @JsonKey()
  final String category;
// e.g., 'meeting', 'gym', 'work'
  @override
  @JsonKey()
  final bool isAllDay;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  final int? colorValue;

  @override
  String toString() {
    return 'CalendarEventModel(id: $id, title: $title, startTime: $startTime, endTime: $endTime, description: $description, category: $category, isAllDay: $isAllDay, isCompleted: $isCompleted, colorValue: $colorValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarEventModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isAllDay, isAllDay) ||
                other.isAllDay == isAllDay) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.colorValue, colorValue) ||
                other.colorValue == colorValue));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, startTime, endTime,
      description, category, isAllDay, isCompleted, colorValue);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarEventModelImplCopyWith<_$CalendarEventModelImpl> get copyWith =>
      __$$CalendarEventModelImplCopyWithImpl<_$CalendarEventModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CalendarEventModelImplToJson(
      this,
    );
  }
}

abstract class _CalendarEventModel implements CalendarEventModel {
  const factory _CalendarEventModel(
      {required final String id,
      required final String title,
      required final DateTime startTime,
      required final DateTime endTime,
      final String? description,
      final String category,
      final bool isAllDay,
      final bool isCompleted,
      final int? colorValue}) = _$CalendarEventModelImpl;

  factory _CalendarEventModel.fromJson(Map<String, dynamic> json) =
      _$CalendarEventModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  String? get description;
  @override
  String get category;
  @override // e.g., 'meeting', 'gym', 'work'
  bool get isAllDay;
  @override
  bool get isCompleted;
  @override
  int? get colorValue;
  @override
  @JsonKey(ignore: true)
  _$$CalendarEventModelImplCopyWith<_$CalendarEventModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
