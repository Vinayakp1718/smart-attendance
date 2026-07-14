// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Attendance _$AttendanceFromJson(Map<String, dynamic> json) {
  return _Attendance.fromJson(json);
}

/// @nodoc
mixin _$Attendance {
  int get attendanceId => throw _privateConstructorUsedError;
  int get employeeId => throw _privateConstructorUsedError;
  String get attendanceDate =>
      throw _privateConstructorUsedError; // Format: YYYY-MM-DD
  DateTime get checkInTime => throw _privateConstructorUsedError;
  DateTime? get checkOutTime => throw _privateConstructorUsedError;
  DateTime? get breakStartTime => throw _privateConstructorUsedError;
  DateTime? get breakEndTime => throw _privateConstructorUsedError;
  double get workingHours => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // Present, Absent, Half Day, Late
  String get locationType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AttendanceCopyWith<Attendance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttendanceCopyWith<$Res> {
  factory $AttendanceCopyWith(
          Attendance value, $Res Function(Attendance) then) =
      _$AttendanceCopyWithImpl<$Res, Attendance>;
  @useResult
  $Res call(
      {int attendanceId,
      int employeeId,
      String attendanceDate,
      DateTime checkInTime,
      DateTime? checkOutTime,
      DateTime? breakStartTime,
      DateTime? breakEndTime,
      double workingHours,
      double latitude,
      double longitude,
      String status,
      String locationType});
}

/// @nodoc
class _$AttendanceCopyWithImpl<$Res, $Val extends Attendance>
    implements $AttendanceCopyWith<$Res> {
  _$AttendanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attendanceId = null,
    Object? employeeId = null,
    Object? attendanceDate = null,
    Object? checkInTime = null,
    Object? checkOutTime = freezed,
    Object? breakStartTime = freezed,
    Object? breakEndTime = freezed,
    Object? workingHours = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? status = null,
    Object? locationType = null,
  }) {
    return _then(_value.copyWith(
      attendanceId: null == attendanceId
          ? _value.attendanceId
          : attendanceId // ignore: cast_nullable_to_non_nullable
              as int,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as int,
      attendanceDate: null == attendanceDate
          ? _value.attendanceDate
          : attendanceDate // ignore: cast_nullable_to_non_nullable
              as String,
      checkInTime: null == checkInTime
          ? _value.checkInTime
          : checkInTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      checkOutTime: freezed == checkOutTime
          ? _value.checkOutTime
          : checkOutTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      breakStartTime: freezed == breakStartTime
          ? _value.breakStartTime
          : breakStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      breakEndTime: freezed == breakEndTime
          ? _value.breakEndTime
          : breakEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      workingHours: null == workingHours
          ? _value.workingHours
          : workingHours // ignore: cast_nullable_to_non_nullable
              as double,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AttendanceImplCopyWith<$Res>
    implements $AttendanceCopyWith<$Res> {
  factory _$$AttendanceImplCopyWith(
          _$AttendanceImpl value, $Res Function(_$AttendanceImpl) then) =
      __$$AttendanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int attendanceId,
      int employeeId,
      String attendanceDate,
      DateTime checkInTime,
      DateTime? checkOutTime,
      DateTime? breakStartTime,
      DateTime? breakEndTime,
      double workingHours,
      double latitude,
      double longitude,
      String status,
      String locationType});
}

/// @nodoc
class __$$AttendanceImplCopyWithImpl<$Res>
    extends _$AttendanceCopyWithImpl<$Res, _$AttendanceImpl>
    implements _$$AttendanceImplCopyWith<$Res> {
  __$$AttendanceImplCopyWithImpl(
      _$AttendanceImpl _value, $Res Function(_$AttendanceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attendanceId = null,
    Object? employeeId = null,
    Object? attendanceDate = null,
    Object? checkInTime = null,
    Object? checkOutTime = freezed,
    Object? breakStartTime = freezed,
    Object? breakEndTime = freezed,
    Object? workingHours = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? status = null,
    Object? locationType = null,
  }) {
    return _then(_$AttendanceImpl(
      attendanceId: null == attendanceId
          ? _value.attendanceId
          : attendanceId // ignore: cast_nullable_to_non_nullable
              as int,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as int,
      attendanceDate: null == attendanceDate
          ? _value.attendanceDate
          : attendanceDate // ignore: cast_nullable_to_non_nullable
              as String,
      checkInTime: null == checkInTime
          ? _value.checkInTime
          : checkInTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      checkOutTime: freezed == checkOutTime
          ? _value.checkOutTime
          : checkOutTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      breakStartTime: freezed == breakStartTime
          ? _value.breakStartTime
          : breakStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      breakEndTime: freezed == breakEndTime
          ? _value.breakEndTime
          : breakEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      workingHours: null == workingHours
          ? _value.workingHours
          : workingHours // ignore: cast_nullable_to_non_nullable
              as double,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AttendanceImpl implements _Attendance {
  const _$AttendanceImpl(
      {required this.attendanceId,
      required this.employeeId,
      required this.attendanceDate,
      required this.checkInTime,
      this.checkOutTime,
      this.breakStartTime,
      this.breakEndTime,
      required this.workingHours,
      required this.latitude,
      required this.longitude,
      required this.status,
      this.locationType = 'Office'});

  factory _$AttendanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttendanceImplFromJson(json);

  @override
  final int attendanceId;
  @override
  final int employeeId;
  @override
  final String attendanceDate;
// Format: YYYY-MM-DD
  @override
  final DateTime checkInTime;
  @override
  final DateTime? checkOutTime;
  @override
  final DateTime? breakStartTime;
  @override
  final DateTime? breakEndTime;
  @override
  final double workingHours;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String status;
// Present, Absent, Half Day, Late
  @override
  @JsonKey()
  final String locationType;

  @override
  String toString() {
    return 'Attendance(attendanceId: $attendanceId, employeeId: $employeeId, attendanceDate: $attendanceDate, checkInTime: $checkInTime, checkOutTime: $checkOutTime, breakStartTime: $breakStartTime, breakEndTime: $breakEndTime, workingHours: $workingHours, latitude: $latitude, longitude: $longitude, status: $status, locationType: $locationType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttendanceImpl &&
            (identical(other.attendanceId, attendanceId) ||
                other.attendanceId == attendanceId) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.attendanceDate, attendanceDate) ||
                other.attendanceDate == attendanceDate) &&
            (identical(other.checkInTime, checkInTime) ||
                other.checkInTime == checkInTime) &&
            (identical(other.checkOutTime, checkOutTime) ||
                other.checkOutTime == checkOutTime) &&
            (identical(other.breakStartTime, breakStartTime) ||
                other.breakStartTime == breakStartTime) &&
            (identical(other.breakEndTime, breakEndTime) ||
                other.breakEndTime == breakEndTime) &&
            (identical(other.workingHours, workingHours) ||
                other.workingHours == workingHours) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.locationType, locationType) ||
                other.locationType == locationType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      attendanceId,
      employeeId,
      attendanceDate,
      checkInTime,
      checkOutTime,
      breakStartTime,
      breakEndTime,
      workingHours,
      latitude,
      longitude,
      status,
      locationType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AttendanceImplCopyWith<_$AttendanceImpl> get copyWith =>
      __$$AttendanceImplCopyWithImpl<_$AttendanceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AttendanceImplToJson(
      this,
    );
  }
}

abstract class _Attendance implements Attendance {
  const factory _Attendance(
      {required final int attendanceId,
      required final int employeeId,
      required final String attendanceDate,
      required final DateTime checkInTime,
      final DateTime? checkOutTime,
      final DateTime? breakStartTime,
      final DateTime? breakEndTime,
      required final double workingHours,
      required final double latitude,
      required final double longitude,
      required final String status,
      final String locationType}) = _$AttendanceImpl;

  factory _Attendance.fromJson(Map<String, dynamic> json) =
      _$AttendanceImpl.fromJson;

  @override
  int get attendanceId;
  @override
  int get employeeId;
  @override
  String get attendanceDate;
  @override // Format: YYYY-MM-DD
  DateTime get checkInTime;
  @override
  DateTime? get checkOutTime;
  @override
  DateTime? get breakStartTime;
  @override
  DateTime? get breakEndTime;
  @override
  double get workingHours;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String get status;
  @override // Present, Absent, Half Day, Late
  String get locationType;
  @override
  @JsonKey(ignore: true)
  _$$AttendanceImplCopyWith<_$AttendanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
