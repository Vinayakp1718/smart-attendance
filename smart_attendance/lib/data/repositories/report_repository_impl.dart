import 'package:dio/dio.dart';
import '../../domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:5170/api'));

  @override
  Future<List<Map<String, dynamic>>> getFilteredAttendance({
    String? startDate,
    String? endDate,
    int? employeeId,
    String? department,
    String? status,
  }) async {
    final response = await _dio.get('/report/attendance', queryParameters: {
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
      if (employeeId != null) 'employeeId': employeeId,
      if (department != null) 'department': department,
      if (status != null) 'status': status,
    });
    final list = response.data as List;
    return list.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  @override
  Future<Map<String, dynamic>> getDashboardMetrics() async {
    final response = await _dio.get('/dashboard/metrics');
    return Map<String, dynamic>.from(response.data);
  }

  @override
  Future<List<Map<String, dynamic>>> getPayrollSummary({
    required int month,
    required int year,
  }) async {
    final response = await _dio.get('/report/payroll', queryParameters: {
      'month': month,
      'year': year,
    });
    final list = response.data as List;
    return list.map((e) => Map<String, dynamic>.from(e)).toList();
  }
}
