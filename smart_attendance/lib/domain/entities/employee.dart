import 'package:freezed_annotation/freezed_annotation.dart';
import 'role.dart';

part 'employee.freezed.dart';
part 'employee.g.dart';

@freezed
class Employee with _$Employee {
  const factory Employee({
    required int employeeId,
    required String employeeCode,
    required String firstName,
    required String lastName,
    required String email,
    required String mobileNumber,
    required String department,
    required String designation,
    required String branch,
    required DateTime joiningDate,
    required DateTime dateOfBirth,
    required String address,
    String? profilePhoto,
    required bool status,
    required UserRole role,
    @Default('India') String shift,
    required DateTime createdDate,
    int? reportingToId,
  }) = _Employee;

  factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);
}
