// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaveBalanceImpl _$$LeaveBalanceImplFromJson(Map<String, dynamic> json) =>
    _$LeaveBalanceImpl(
      employeeId: (json['employeeId'] as num).toInt(),
      sickLeave: (json['sickLeave'] as num).toDouble(),
      casualLeave: (json['casualLeave'] as num).toDouble(),
      paidLeave: (json['paidLeave'] as num).toDouble(),
    );

Map<String, dynamic> _$$LeaveBalanceImplToJson(_$LeaveBalanceImpl instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'sickLeave': instance.sickLeave,
      'casualLeave': instance.casualLeave,
      'paidLeave': instance.paidLeave,
    };
