// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaveRequestImpl _$$LeaveRequestImplFromJson(Map<String, dynamic> json) =>
    _$LeaveRequestImpl(
      leaveId: (json['leaveId'] as num).toInt(),
      employeeId: (json['employeeId'] as num).toInt(),
      leaveType: json['leaveType'] as String,
      fromDate: json['fromDate'] as String,
      toDate: json['toDate'] as String,
      reason: json['reason'] as String,
      status: json['status'] as String,
      appliedDate: DateTime.parse(json['appliedDate'] as String),
    );

Map<String, dynamic> _$$LeaveRequestImplToJson(_$LeaveRequestImpl instance) =>
    <String, dynamic>{
      'leaveId': instance.leaveId,
      'employeeId': instance.employeeId,
      'leaveType': instance.leaveType,
      'fromDate': instance.fromDate,
      'toDate': instance.toDate,
      'reason': instance.reason,
      'status': instance.status,
      'appliedDate': instance.appliedDate.toIso8601String(),
    };
