import 'package:dio/dio.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/repositories/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:5170/api'));

  @override
  Future<List<Attendance>> getAttendanceHistory(int employeeId) async {
    final response = await _dio.get('/attendance/history/$employeeId');
    final list = response.data as List;
    return list.map((e) => Attendance.fromJson(e)).toList();
  }

  @override
  Future<List<Attendance>> getAllAttendanceHistory() async {
    final response = await _dio.get('/attendance/history');
    final list = response.data as List;
    return list.map((e) => Attendance.fromJson(e)).toList();
  }

  @override
  Future<Attendance?> getTodayAttendance(int employeeId) async {
    final response = await _dio.get('/attendance/today/$employeeId');
    if (response.data == null || response.data is! Map) return null;
    return Attendance.fromJson(response.data);
  }

  @override
  Future<Attendance> checkIn(int employeeId, double latitude, double longitude, {String locationType = 'Office'}) async {
    final response = await _dio.post('/attendance/checkin', data: {
      'employeeId': employeeId,
      'latitude': latitude,
      'longitude': longitude,
      'locationType': locationType,
    });
    return Attendance.fromJson(response.data);
  }

  @override
  Future<Attendance> checkOut(int employeeId) async {
    final response = await _dio.post('/attendance/checkout', data: {
      'employeeId': employeeId,
    });
    return Attendance.fromJson(response.data);
  }

  @override
  Future<Attendance> startBreak(int employeeId) async {
    final response = await _dio.post('/attendance/break/start', data: {
      'employeeId': employeeId,
    });
    return Attendance.fromJson(response.data);
  }

  @override
  Future<Attendance> endBreak(int employeeId) async {
    final response = await _dio.post('/attendance/break/end', data: {
      'employeeId': employeeId,
    });
    return Attendance.fromJson(response.data);
  }
}
