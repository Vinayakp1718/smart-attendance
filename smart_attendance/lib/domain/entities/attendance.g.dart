// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttendanceImpl _$$AttendanceImplFromJson(Map<String, dynamic> json) =>
    _$AttendanceImpl(
      attendanceId: (json['attendanceId'] as num).toInt(),
      employeeId: (json['employeeId'] as num).toInt(),
      attendanceDate: json['attendanceDate'] as String,
      checkInTime: DateTime.parse(json['checkInTime'] as String),
      checkOutTime: json['checkOutTime'] == null
          ? null
          : DateTime.parse(json['checkOutTime'] as String),
      breakStartTime: json['breakStartTime'] == null
          ? null
          : DateTime.parse(json['breakStartTime'] as String),
      breakEndTime: json['breakEndTime'] == null
          ? null
          : DateTime.parse(json['breakEndTime'] as String),
      workingHours: (json['workingHours'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      status: json['status'] as String,
      locationType: json['locationType'] as String? ?? 'Office',
    );

Map<String, dynamic> _$$AttendanceImplToJson(_$AttendanceImpl instance) =>
    <String, dynamic>{
      'attendanceId': instance.attendanceId,
      'employeeId': instance.employeeId,
      'attendanceDate': instance.attendanceDate,
      'checkInTime': instance.checkInTime.toIso8601String(),
      'checkOutTime': instance.checkOutTime?.toIso8601String(),
      'breakStartTime': instance.breakStartTime?.toIso8601String(),
      'breakEndTime': instance.breakEndTime?.toIso8601String(),
      'workingHours': instance.workingHours,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'status': instance.status,
      'locationType': instance.locationType,
    };
