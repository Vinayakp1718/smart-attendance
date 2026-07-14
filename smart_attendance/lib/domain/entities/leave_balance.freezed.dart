// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leave_balance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LeaveBalance _$LeaveBalanceFromJson(Map<String, dynamic> json) {
  return _LeaveBalance.fromJson(json);
}

/// @nodoc
mixin _$LeaveBalance {
  int get employeeId => throw _privateConstructorUsedError;
  double get sickLeave => throw _privateConstructorUsedError;
  double get casualLeave => throw _privateConstructorUsedError;
  double get paidLeave => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LeaveBalanceCopyWith<LeaveBalance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaveBalanceCopyWith<$Res> {
  factory $LeaveBalanceCopyWith(
          LeaveBalance value, $Res Function(LeaveBalance) then) =
      _$LeaveBalanceCopyWithImpl<$Res, LeaveBalance>;
  @useResult
  $Res call(
      {int employeeId, double sickLeave, double casualLeave, double paidLeave});
}

/// @nodoc
class _$LeaveBalanceCopyWithImpl<$Res, $Val extends LeaveBalance>
    implements $LeaveBalanceCopyWith<$Res> {
  _$LeaveBalanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? sickLeave = null,
    Object? casualLeave = null,
    Object? paidLeave = null,
  }) {
    return _then(_value.copyWith(
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as int,
      sickLeave: null == sickLeave
          ? _value.sickLeave
          : sickLeave // ignore: cast_nullable_to_non_nullable
              as double,
      casualLeave: null == casualLeave
          ? _value.casualLeave
          : casualLeave // ignore: cast_nullable_to_non_nullable
              as double,
      paidLeave: null == paidLeave
          ? _value.paidLeave
          : paidLeave // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LeaveBalanceImplCopyWith<$Res>
    implements $LeaveBalanceCopyWith<$Res> {
  factory _$$LeaveBalanceImplCopyWith(
          _$LeaveBalanceImpl value, $Res Function(_$LeaveBalanceImpl) then) =
      __$$LeaveBalanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int employeeId, double sickLeave, double casualLeave, double paidLeave});
}

/// @nodoc
class __$$LeaveBalanceImplCopyWithImpl<$Res>
    extends _$LeaveBalanceCopyWithImpl<$Res, _$LeaveBalanceImpl>
    implements _$$LeaveBalanceImplCopyWith<$Res> {
  __$$LeaveBalanceImplCopyWithImpl(
      _$LeaveBalanceImpl _value, $Res Function(_$LeaveBalanceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? sickLeave = null,
    Object? casualLeave = null,
    Object? paidLeave = null,
  }) {
    return _then(_$LeaveBalanceImpl(
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as int,
      sickLeave: null == sickLeave
          ? _value.sickLeave
          : sickLeave // ignore: cast_nullable_to_non_nullable
              as double,
      casualLeave: null == casualLeave
          ? _value.casualLeave
          : casualLeave // ignore: cast_nullable_to_non_nullable
              as double,
      paidLeave: null == paidLeave
          ? _value.paidLeave
          : paidLeave // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LeaveBalanceImpl implements _LeaveBalance {
  const _$LeaveBalanceImpl(
      {required this.employeeId,
      required this.sickLeave,
      required this.casualLeave,
      required this.paidLeave});

  factory _$LeaveBalanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaveBalanceImplFromJson(json);

  @override
  final int employeeId;
  @override
  final double sickLeave;
  @override
  final double casualLeave;
  @override
  final double paidLeave;

  @override
  String toString() {
    return 'LeaveBalance(employeeId: $employeeId, sickLeave: $sickLeave, casualLeave: $casualLeave, paidLeave: $paidLeave)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaveBalanceImpl &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.sickLeave, sickLeave) ||
                other.sickLeave == sickLeave) &&
            (identical(other.casualLeave, casualLeave) ||
                other.casualLeave == casualLeave) &&
            (identical(other.paidLeave, paidLeave) ||
                other.paidLeave == paidLeave));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, employeeId, sickLeave, casualLeave, paidLeave);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaveBalanceImplCopyWith<_$LeaveBalanceImpl> get copyWith =>
      __$$LeaveBalanceImplCopyWithImpl<_$LeaveBalanceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaveBalanceImplToJson(
      this,
    );
  }
}

abstract class _LeaveBalance implements LeaveBalance {
  const factory _LeaveBalance(
      {required final int employeeId,
      required final double sickLeave,
      required final double casualLeave,
      required final double paidLeave}) = _$LeaveBalanceImpl;

  factory _LeaveBalance.fromJson(Map<String, dynamic> json) =
      _$LeaveBalanceImpl.fromJson;

  @override
  int get employeeId;
  @override
  double get sickLeave;
  @override
  double get casualLeave;
  @override
  double get paidLeave;
  @override
  @JsonKey(ignore: true)
  _$$LeaveBalanceImplCopyWith<_$LeaveBalanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
