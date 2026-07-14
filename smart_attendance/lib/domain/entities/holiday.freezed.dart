// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'holiday.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Holiday _$HolidayFromJson(Map<String, dynamic> json) {
  return _Holiday.fromJson(json);
}

/// @nodoc
mixin _$Holiday {
  int get holidayId => throw _privateConstructorUsedError;
  String get holidayName => throw _privateConstructorUsedError;
  String get holidayDate => throw _privateConstructorUsedError; // YYYY-MM-DD
  String get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HolidayCopyWith<Holiday> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HolidayCopyWith<$Res> {
  factory $HolidayCopyWith(Holiday value, $Res Function(Holiday) then) =
      _$HolidayCopyWithImpl<$Res, Holiday>;
  @useResult
  $Res call(
      {int holidayId,
      String holidayName,
      String holidayDate,
      String description});
}

/// @nodoc
class _$HolidayCopyWithImpl<$Res, $Val extends Holiday>
    implements $HolidayCopyWith<$Res> {
  _$HolidayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? holidayId = null,
    Object? holidayName = null,
    Object? holidayDate = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      holidayId: null == holidayId
          ? _value.holidayId
          : holidayId // ignore: cast_nullable_to_non_nullable
              as int,
      holidayName: null == holidayName
          ? _value.holidayName
          : holidayName // ignore: cast_nullable_to_non_nullable
              as String,
      holidayDate: null == holidayDate
          ? _value.holidayDate
          : holidayDate // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HolidayImplCopyWith<$Res> implements $HolidayCopyWith<$Res> {
  factory _$$HolidayImplCopyWith(
          _$HolidayImpl value, $Res Function(_$HolidayImpl) then) =
      __$$HolidayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int holidayId,
      String holidayName,
      String holidayDate,
      String description});
}

/// @nodoc
class __$$HolidayImplCopyWithImpl<$Res>
    extends _$HolidayCopyWithImpl<$Res, _$HolidayImpl>
    implements _$$HolidayImplCopyWith<$Res> {
  __$$HolidayImplCopyWithImpl(
      _$HolidayImpl _value, $Res Function(_$HolidayImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? holidayId = null,
    Object? holidayName = null,
    Object? holidayDate = null,
    Object? description = null,
  }) {
    return _then(_$HolidayImpl(
      holidayId: null == holidayId
          ? _value.holidayId
          : holidayId // ignore: cast_nullable_to_non_nullable
              as int,
      holidayName: null == holidayName
          ? _value.holidayName
          : holidayName // ignore: cast_nullable_to_non_nullable
              as String,
      holidayDate: null == holidayDate
          ? _value.holidayDate
          : holidayDate // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HolidayImpl implements _Holiday {
  const _$HolidayImpl(
      {required this.holidayId,
      required this.holidayName,
      required this.holidayDate,
      required this.description});

  factory _$HolidayImpl.fromJson(Map<String, dynamic> json) =>
      _$$HolidayImplFromJson(json);

  @override
  final int holidayId;
  @override
  final String holidayName;
  @override
  final String holidayDate;
// YYYY-MM-DD
  @override
  final String description;

  @override
  String toString() {
    return 'Holiday(holidayId: $holidayId, holidayName: $holidayName, holidayDate: $holidayDate, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HolidayImpl &&
            (identical(other.holidayId, holidayId) ||
                other.holidayId == holidayId) &&
            (identical(other.holidayName, holidayName) ||
                other.holidayName == holidayName) &&
            (identical(other.holidayDate, holidayDate) ||
                other.holidayDate == holidayDate) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, holidayId, holidayName, holidayDate, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HolidayImplCopyWith<_$HolidayImpl> get copyWith =>
      __$$HolidayImplCopyWithImpl<_$HolidayImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HolidayImplToJson(
      this,
    );
  }
}

abstract class _Holiday implements Holiday {
  const factory _Holiday(
      {required final int holidayId,
      required final String holidayName,
      required final String holidayDate,
      required final String description}) = _$HolidayImpl;

  factory _Holiday.fromJson(Map<String, dynamic> json) = _$HolidayImpl.fromJson;

  @override
  int get holidayId;
  @override
  String get holidayName;
  @override
  String get holidayDate;
  @override // YYYY-MM-DD
  String get description;
  @override
  @JsonKey(ignore: true)
  _$$HolidayImplCopyWith<_$HolidayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
