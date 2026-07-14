// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmployeeImpl _$$EmployeeImplFromJson(Map<String, dynamic> json) =>
    _$EmployeeImpl(
      employeeId: (json['employeeId'] as num).toInt(),
      employeeCode: json['employeeCode'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      mobileNumber: json['mobileNumber'] as String,
      department: json['department'] as String,
      designation: json['designation'] as String,
      branch: json['branch'] as String,
      joiningDate: DateTime.parse(json['joiningDate'] as String),
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      address: json['address'] as String,
      profilePhoto: json['profilePhoto'] as String?,
      status: json['status'] as bool,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      shift: json['shift'] as String? ?? 'India',
      createdDate: DateTime.parse(json['createdDate'] as String),
      reportingToId: (json['reportingToId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$EmployeeImplToJson(_$EmployeeImpl instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'employeeCode': instance.employeeCode,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'mobileNumber': instance.mobileNumber,
      'department': instance.department,
      'designation': instance.designation,
      'branch': instance.branch,
      'joiningDate': instance.joiningDate.toIso8601String(),
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'address': instance.address,
      'profilePhoto': instance.profilePhoto,
      'status': instance.status,
      'role': _$UserRoleEnumMap[instance.role]!,
      'shift': instance.shift,
      'createdDate': instance.createdDate.toIso8601String(),
      'reportingToId': instance.reportingToId,
    };

const _$UserRoleEnumMap = {
  UserRole.superAdmin: 'SuperAdmin',
  UserRole.hrManager: 'HRManager',
  UserRole.employee: 'Employee',
};
