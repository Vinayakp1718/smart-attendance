// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leave_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LeaveRequest _$LeaveRequestFromJson(Map<String, dynamic> json) {
  return _LeaveRequest.fromJson(json);
}

/// @nodoc
mixin _$LeaveRequest {
  int get leaveId => throw _privateConstructorUsedError;
  int get employeeId => throw _privateConstructorUsedError;
  String get leaveType =>
      throw _privateConstructorUsedError; // Sick Leave, Casual Leave, Paid Leave
  String get fromDate => throw _privateConstructorUsedError; // YYYY-MM-DD
  String get toDate => throw _privateConstructorUsedError; // YYYY-MM-DD
  String get reason => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // Pending, Approved, Rejected
  DateTime get appliedDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LeaveRequestCopyWith<LeaveRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaveRequestCopyWith<$Res> {
  factory $LeaveRequestCopyWith(
          LeaveRequest value, $Res Function(LeaveRequest) then) =
      _$LeaveRequestCopyWithImpl<$Res, LeaveRequest>;
  @useResult
  $Res call(
      {int leaveId,
      int employeeId,
      String leaveType,
      String fromDate,
      String toDate,
      String reason,
      String status,
      DateTime appliedDate});
}

/// @nodoc
class _$LeaveRequestCopyWithImpl<$Res, $Val extends LeaveRequest>
    implements $LeaveRequestCopyWith<$Res> {
  _$LeaveRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leaveId = null,
    Object? employeeId = null,
    Object? leaveType = null,
    Object? fromDate = null,
    Object? toDate = null,
    Object? reason = null,
    Object? status = null,
    Object? appliedDate = null,
  }) {
    return _then(_value.copyWith(
      leaveId: null == leaveId
          ? _value.leaveId
          : leaveId // ignore: cast_nullable_to_non_nullable
              as int,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as int,
      leaveType: null == leaveType
          ? _value.leaveType
          : leaveType // ignore: cast_nullable_to_non_nullable
              as String,
      fromDate: null == fromDate
          ? _value.fromDate
          : fromDate // ignore: cast_nullable_to_non_nullable
              as String,
      toDate: null == toDate
          ? _value.toDate
          : toDate // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      appliedDate: null == appliedDate
          ? _value.appliedDate
          : appliedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LeaveRequestImplCopyWith<$Res>
    implements $LeaveRequestCopyWith<$Res> {
  factory _$$LeaveRequestImplCopyWith(
          _$LeaveRequestImpl value, $Res Function(_$LeaveRequestImpl) then) =
      __$$LeaveRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int leaveId,
      int employeeId,
      String leaveType,
      String fromDate,
      String toDate,
      String reason,
      String status,
      DateTime appliedDate});
}

/// @nodoc
class __$$LeaveRequestImplCopyWithImpl<$Res>
    extends _$LeaveRequestCopyWithImpl<$Res, _$LeaveRequestImpl>
    implements _$$LeaveRequestImplCopyWith<$Res> {
  __$$LeaveRequestImplCopyWithImpl(
      _$LeaveRequestImpl _value, $Res Function(_$LeaveRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leaveId = null,
    Object? employeeId = null,
    Object? leaveType = null,
    Object? fromDate = null,
    Object? toDate = null,
    Object? reason = null,
    Object? status = null,
    Object? appliedDate = null,
  }) {
    return _then(_$LeaveRequestImpl(
      leaveId: null == leaveId
          ? _value.leaveId
          : leaveId // ignore: cast_nullable_to_non_nullable
              as int,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as int,
      leaveType: null == leaveType
          ? _value.leaveType
          : leaveType // ignore: cast_nullable_to_non_nullable
              as String,
      fromDate: null == fromDate
          ? _value.fromDate
          : fromDate // ignore: cast_nullable_to_non_nullable
              as String,
      toDate: null == toDate
          ? _value.toDate
          : toDate // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      appliedDate: null == appliedDate
          ? _value.appliedDate
          : appliedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LeaveRequestImpl implements _LeaveRequest {
  const _$LeaveRequestImpl(
      {required this.leaveId,
      required this.employeeId,
      required this.leaveType,
      required this.fromDate,
      required this.toDate,
      required this.reason,
      required this.status,
      required this.appliedDate});

  factory _$LeaveRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaveRequestImplFromJson(json);

  @override
  final int leaveId;
  @override
  final int employeeId;
  @override
  final String leaveType;
// Sick Leave, Casual Leave, Paid Leave
  @override
  final String fromDate;
// YYYY-MM-DD
  @override
  final String toDate;
// YYYY-MM-DD
  @override
  final String reason;
  @override
  final String status;
// Pending, Approved, Rejected
  @override
  final DateTime appliedDate;

  @override
  String toString() {
    return 'LeaveRequest(leaveId: $leaveId, employeeId: $employeeId, leaveType: $leaveType, fromDate: $fromDate, toDate: $toDate, reason: $reason, status: $status, appliedDate: $appliedDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaveRequestImpl &&
            (identical(other.leaveId, leaveId) || other.leaveId == leaveId) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.leaveType, leaveType) ||
                other.leaveType == leaveType) &&
            (identical(other.fromDate, fromDate) ||
                other.fromDate == fromDate) &&
            (identical(other.toDate, toDate) || other.toDate == toDate) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.appliedDate, appliedDate) ||
                other.appliedDate == appliedDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, leaveId, employeeId, leaveType,
      fromDate, toDate, reason, status, appliedDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaveRequestImplCopyWith<_$LeaveRequestImpl> get copyWith =>
      __$$LeaveRequestImplCopyWithImpl<_$LeaveRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaveRequestImplToJson(
      this,
    );
  }
}

abstract class _LeaveRequest implements LeaveRequest {
  const factory _LeaveRequest(
      {required final int leaveId,
      required final int employeeId,
      required final String leaveType,
      required final String fromDate,
      required final String toDate,
      required final String reason,
      required final String status,
      required final DateTime appliedDate}) = _$LeaveRequestImpl;

  factory _LeaveRequest.fromJson(Map<String, dynamic> json) =
      _$LeaveRequestImpl.fromJson;

  @override
  int get leaveId;
  @override
  int get employeeId;
  @override
  String get leaveType;
  @override // Sick Leave, Casual Leave, Paid Leave
  String get fromDate;
  @override // YYYY-MM-DD
  String get toDate;
  @override // YYYY-MM-DD
  String get reason;
  @override
  String get status;
  @override // Pending, Approved, Rejected
  DateTime get appliedDate;
  @override
  @JsonKey(ignore: true)
  _$$LeaveRequestImplCopyWith<_$LeaveRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
