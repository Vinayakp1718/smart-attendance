import 'dart:math';
import '../../core/services/storage_service.dart';

class AttendanceApiService {
  final StorageService _storage;

  AttendanceApiService(this._storage);

  Future<List<Map<String, dynamic>>> getAttendanceHistory(int employeeId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final List<Map<String, dynamic>> records = _storage.getAttendance();
    return records.where((r) => r['employeeId'] == employeeId).toList();
  }

  Future<List<Map<String, dynamic>>> getAllAttendanceHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _storage.getAttendance();
  }

  Future<Map<String, dynamic>?> getTodayAttendance(int employeeId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final List<Map<String, dynamic>> records = _storage.getAttendance();
    final todayStr = DateTime.now().toLocal().toString().substring(0, 10);
    
    try {
      return records.firstWhere(
        (r) => r['employeeId'] == employeeId && r['attendanceDate'] == todayStr
      );
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>> checkIn(int employeeId, double lat, double lon, {String locationType = 'Office'}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final List<Map<String, dynamic>> records = _storage.getAttendance();
    final todayStr = DateTime.now().toLocal().toString().substring(0, 10);

    // Verify if already checked in today
    final alreadyCheckedIn = records.any(
      (r) => r['employeeId'] == employeeId && r['attendanceDate'] == todayStr
    );
    if (alreadyCheckedIn) {
      throw Exception("Already checked in for today!");
    }

    final DateTime now = DateTime.now();
    
    // Status Rules: Late if checked in after 9:30 AM
    String status = "Present";
    final int hour = now.hour;
    final int minute = now.minute;
    if (hour > 9 || (hour == 9 && minute > 30)) {
      status = "Late";
    }

    final int newId = records.isEmpty 
        ? 1 
        : records.map((e) => e['attendanceId'] as int).reduce(max) + 1;

    final Map<String, dynamic> newRecord = {
      "attendanceId": newId,
      "employeeId": employeeId,
      "attendanceDate": todayStr,
      "checkInTime": now.toUtc().toIso8601String(),
      "checkOutTime": null,
      "breakStartTime": null,
      "breakEndTime": null,
      "workingHours": 0.0,
      "latitude": lat,
      "longitude": lon,
      "status": status,
      "locationType": locationType,
    };

    records.add(newRecord);
    await _storage.saveAttendance(records);
    return newRecord;
  }

  Future<Map<String, dynamic>> checkOut(int employeeId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final List<Map<String, dynamic>> records = _storage.getAttendance();
    final todayStr = DateTime.now().toLocal().toString().substring(0, 10);

    final index = records.indexWhere(
      (r) => r['employeeId'] == employeeId && r['attendanceDate'] == todayStr
    );
    if (index == -1) {
      throw Exception("Must check in first before checking out!");
    }

    final Map<String, dynamic> record = records[index];
    if (record['checkOutTime'] != null) {
      throw Exception("Already checked out for today!");
    }

    final DateTime now = DateTime.now();
    final DateTime checkIn = DateTime.parse(record['checkInTime']);
    
    // Calculate Break Time in hours
    double breakHours = 0.0;
    if (record['breakStartTime'] != null) {
      final DateTime breakStart = DateTime.parse(record['breakStartTime']);
      final DateTime breakEnd = record['breakEndTime'] != null 
          ? DateTime.parse(record['breakEndTime']) 
          : now; // If break end was not clicked, assume ended now
      breakHours = breakEnd.difference(breakStart).inMinutes / 60.0;
    }

    // Calculate Working Hours
    final double rawWorkingHours = now.difference(checkIn).inMinutes / 60.0;
    double netWorkingHours = double.parse((rawWorkingHours - breakHours).toStringAsFixed(2));
    if (netWorkingHours < 0) netWorkingHours = 0;

    // Status rule update: Half Day if working hours < 4
    String status = record['status'];
    if (netWorkingHours < 4.0) {
      status = "Half Day";
    }

    final Map<String, dynamic> updatedRecord = {
      ...record,
      "checkOutTime": now.toUtc().toIso8601String(),
      "workingHours": netWorkingHours,
      "status": status,
    };

    records[index] = updatedRecord;
    await _storage.saveAttendance(records);
    return updatedRecord;
  }

  Future<Map<String, dynamic>> startBreak(int employeeId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final List<Map<String, dynamic>> records = _storage.getAttendance();
    final todayStr = DateTime.now().toLocal().toString().substring(0, 10);

    final index = records.indexWhere(
      (r) => r['employeeId'] == employeeId && r['attendanceDate'] == todayStr
    );
    if (index == -1) {
      throw Exception("Must check in first!");
    }

    final Map<String, dynamic> record = records[index];
    if (record['checkOutTime'] != null) {
      throw Exception("Already checked out!");
    }
    if (record['breakStartTime'] != null && record['breakEndTime'] == null) {
      throw Exception("Break is already active!");
    }

    final DateTime now = DateTime.now();
    final Map<String, dynamic> updated = {
      ...record,
      "breakStartTime": now.toUtc().toIso8601String(),
      "breakEndTime": null, // Reset break end just in case they take another break
    };

    records[index] = updated;
    await _storage.saveAttendance(records);
    return updated;
  }

  Future<Map<String, dynamic>> endBreak(int employeeId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final List<Map<String, dynamic>> records = _storage.getAttendance();
    final todayStr = DateTime.now().toLocal().toString().substring(0, 10);

    final index = records.indexWhere(
      (r) => r['employeeId'] == employeeId && r['attendanceDate'] == todayStr
    );
    if (index == -1) {
      throw Exception("Must check in first!");
    }

    final Map<String, dynamic> record = records[index];
    if (record['breakStartTime'] == null) {
      throw Exception("Break has not been started yet!");
    }
    if (record['breakEndTime'] != null) {
      throw Exception("Break already ended!");
    }

    final DateTime now = DateTime.now();
    final Map<String, dynamic> updated = {
      ...record,
      "breakEndTime": now.toUtc().toIso8601String(),
    };

    records[index] = updated;
    await _storage.saveAttendance(records);
    return updated;
  }
}
