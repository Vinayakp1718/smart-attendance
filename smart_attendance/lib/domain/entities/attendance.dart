import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance.freezed.dart';
part 'attendance.g.dart';

@freezed
class Attendance with _$Attendance {
  const factory Attendance({
    required int attendanceId,
    required int employeeId,
    required String attendanceDate, // Format: YYYY-MM-DD
    required DateTime checkInTime,
    DateTime? checkOutTime,
    DateTime? breakStartTime,
    DateTime? breakEndTime,
    required double workingHours,
    required double latitude,
    required double longitude,
    required String status, // Present, Absent, Half Day, Late
    @Default('Office') String locationType, // Home, Office, Client Site
  }) = _Attendance;

  factory Attendance.fromJson(Map<String, dynamic> json) => _$AttendanceFromJson(json);
}
