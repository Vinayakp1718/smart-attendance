abstract class ReportRepository {
  Future<List<Map<String, dynamic>>> getFilteredAttendance({
    String? startDate,
    String? endDate,
    int? employeeId,
    String? department,
    String? status,
  });

  Future<Map<String, dynamic>> getDashboardMetrics();

  Future<List<Map<String, dynamic>>> getPayrollSummary({
    required int month,
    required int year,
  });
}
