import '../../core/services/storage_service.dart';

class ReportApiService {
  final StorageService _storage;

  ReportApiService(this._storage);

  /// Filters logs by employee, department, branch, date range, or status.
  Future<List<Map<String, dynamic>>> getFilteredAttendance({
    String? startDate, // YYYY-MM-DD
    String? endDate,   // YYYY-MM-DD
    int? employeeId,
    String? department,
    String? status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final List<Map<String, dynamic>> employees = _storage.getEmployees();
    final List<Map<String, dynamic>> attendance = _storage.getAttendance();

    final List<Map<String, dynamic>> result = [];

    for (var att in attendance) {
      final emp = employees.firstWhere(
        (e) => e['employeeId'] == att['employeeId'],
        orElse: () => <String, dynamic>{}
      );
      
      if (emp.isEmpty) continue;

      // Filter by Employee
      if (employeeId != null && att['employeeId'] != employeeId) continue;

      // Filter by Department
      if (department != null && department.isNotEmpty && emp['department'] != department) continue;

      // Filter by Status
      if (status != null && status.isNotEmpty && att['status'] != status) continue;

      // Filter by Date Range
      if (startDate != null && startDate.isNotEmpty) {
        if (att['attendanceDate'].compareTo(startDate) < 0) continue;
      }
      if (endDate != null && endDate.isNotEmpty) {
        if (att['attendanceDate'].compareTo(endDate) > 0) continue;
      }

      result.add({
        ...att,
        'employeeCode': emp['employeeCode'],
        'firstName': emp['firstName'],
        'lastName': emp['lastName'],
        'department': emp['department'],
        'designation': emp['designation'],
        'branch': emp['branch'],
      });
    }

    return result;
  }

  /// Generates the dashboard overview counts
  Future<Map<String, dynamic>> getDashboardMetrics() async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    final List<Map<String, dynamic>> employees = _storage.getEmployees().where((e) => e['status'] == true).toList();
    final List<Map<String, dynamic>> attendance = _storage.getAttendance();
    final List<Map<String, dynamic>> leaves = _storage.getLeaves();

    final todayStr = DateTime.now().toLocal().toString().substring(0, 10);
    
    final todayAttendance = attendance.where((a) => a['attendanceDate'] == todayStr).toList();
    
    final int totalEmployees = employees.length;
    final int presentToday = todayAttendance.where((a) => a['status'] == 'Present' || a['status'] == 'Late').length;
    final int lateToday = todayAttendance.where((a) => a['status'] == 'Late').length;
    final int halfDayToday = todayAttendance.where((a) => a['status'] == 'Half Day').length;
    final int absentToday = totalEmployees - (presentToday + halfDayToday);
    
    final int pendingLeaves = leaves.where((l) => l['status'] == 'Pending').length;

    // Attendance trend data for the last 7 days
    final List<Map<String, dynamic>> attendanceTrend = [];
    final now = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr = date.toLocal().toString().substring(0, 10);
      final dayAtt = attendance.where((a) => a['attendanceDate'] == dateStr).toList();
      final dayPresent = dayAtt.where((a) => a['status'] == 'Present' || a['status'] == 'Late').length;
      attendanceTrend.add({
        "date": dateStr,
        "present": dayPresent,
        "absent": totalEmployees - dayAtt.length,
      });
    }

    // Department wise employee distribution
    final Map<String, int> deptMap = {};
    for (var emp in employees) {
      final dept = emp['department'] as String;
      deptMap[dept] = (deptMap[dept] ?? 0) + 1;
    }
    final List<Map<String, dynamic>> deptDistribution = deptMap.entries
        .map((entry) => {"department": entry.key, "count": entry.value})
        .toList();

    return {
      "totalEmployees": totalEmployees,
      "presentToday": presentToday,
      "absentToday": absentToday < 0 ? 0 : absentToday,
      "lateToday": lateToday,
      "pendingLeaves": pendingLeaves,
      "attendanceTrend": attendanceTrend,
      "departmentDistribution": deptDistribution,
    };
  }

  /// Generates the payroll summary data
  Future<List<Map<String, dynamic>>> getPayrollSummary({
    required int month, // 1-12
    required int year,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final List<Map<String, dynamic>> employees = _storage.getEmployees();
    final List<Map<String, dynamic>> attendance = _storage.getAttendance();
    final List<Map<String, dynamic>> leaves = _storage.getLeaves();

    final List<Map<String, dynamic>> summary = [];

    // Calculate total days in month
    final int totalDaysInMonth = DateTime(year, month + 1, 0).day;

    for (var emp in employees) {
      final int employeeId = emp['employeeId'] as int;

      // Filter attendance records of this employee for this month/year
      final empAtts = attendance.where((a) {
        final date = DateTime.parse(a['attendanceDate']);
        return a['employeeId'] == employeeId && date.month == month && date.year == year;
      }).toList();

      // Filter leaves of this employee for this month/year that were APPROVED
      final empLeaves = leaves.where((l) {
        if (l['employeeId'] != employeeId || l['status'] != 'Approved') return false;
        final fromDate = DateTime.parse(l['fromDate']);
        final toDate = DateTime.parse(l['toDate']);
        // Check overlap with the month
        return (fromDate.month == month && fromDate.year == year) || 
               (toDate.month == month && toDate.year == year);
      }).toList();

      int leaveDays = 0;
      for (var l in empLeaves) {
        final fromDate = DateTime.parse(l['fromDate']);
        final toDate = DateTime.parse(l['toDate']);
        
        // Clamp leave dates to current month range
        final start = fromDate.month == month ? fromDate.day : 1;
        final end = toDate.month == month ? toDate.day : totalDaysInMonth;
        leaveDays += (end - start + 1);
      }

      final int presentDays = empAtts.where((a) => a['status'] == 'Present' || a['status'] == 'Late').length;
      final int halfDays = empAtts.where((a) => a['status'] == 'Half Day').length;
      
      // Compute total active working days
      final double effectivePresent = presentDays + (halfDays * 0.5);

      // Assume weekend count in a month (usually 8 or 9)
      // Let's count actual Sundays/Saturdays if they are configured as off
      final weekendConfig = _storage.getWeekendConfig();
      final bool saturdayOff = weekendConfig['saturdayOff'] as bool;
      final bool sundayOff = weekendConfig['sundayOff'] as bool;
      
      int weekendDays = 0;
      for (int day = 1; day <= totalDaysInMonth; day++) {
        final date = DateTime(year, month, day);
        if (date.weekday == DateTime.sunday && sundayOff) {
          weekendDays++;
        } else if (date.weekday == DateTime.saturday && saturdayOff) {
          weekendDays++;
        }
      }

      final int workingDays = totalDaysInMonth - weekendDays;
      final double absentDays = workingDays - (effectivePresent + leaveDays);

      summary.add({
        "employeeId": employeeId,
        "employeeCode": emp['employeeCode'],
        "firstName": emp['firstName'],
        "lastName": emp['lastName'],
        "department": emp['department'],
        "designation": emp['designation'],
        "month": month,
        "year": year,
        "presentDays": effectivePresent,
        "absentDays": absentDays < 0 ? 0.0 : absentDays,
        "leaveDays": leaveDays,
        "workingDays": workingDays,
        "totalDays": totalDaysInMonth,
      });
    }

    return summary;
  }
}
