import '../entities/attendance.dart';

abstract class AttendanceRepository {
  Future<List<Attendance>> getAttendanceHistory(int employeeId);
  Future<List<Attendance>> getAllAttendanceHistory();
  Future<Attendance?> getTodayAttendance(int employeeId);
  Future<Attendance> checkIn(int employeeId, double latitude, double longitude, {String locationType = 'Office'});
  Future<Attendance> checkOut(int employeeId);
  Future<Attendance> startBreak(int employeeId);
  Future<Attendance> endBreak(int employeeId);
}
