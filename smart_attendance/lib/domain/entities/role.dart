import 'package:freezed_annotation/freezed_annotation.dart';

enum UserRole {
  @JsonValue('SuperAdmin')
  superAdmin,
  
  @JsonValue('HRManager')
  hrManager,
  
  @JsonValue('Employee')
  employee;

  String get displayName {
    switch (this) {
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.hrManager:
        return 'HR Manager';
      case UserRole.employee:
        return 'Employee';
    }
  }
}
