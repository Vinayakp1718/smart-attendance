import 'dart:math';
import '../../core/services/storage_service.dart';

class LeaveApiService {
  final StorageService _storage;

  LeaveApiService(this._storage);

  Future<List<Map<String, dynamic>>> getLeaveRequests(int employeeId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final List<Map<String, dynamic>> requests = _storage.getLeaves();
    return requests.where((r) => r['employeeId'] == employeeId).toList();
  }

  Future<List<Map<String, dynamic>>> getAllLeaveRequests() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _storage.getLeaves();
  }

  Future<Map<String, dynamic>> getLeaveBalance(int employeeId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final List<Map<String, dynamic>> balances = _storage.getLeaveBalances();
    try {
      return balances.firstWhere((b) => b['employeeId'] == employeeId);
    } catch (_) {
      // Return default if not found
      return {"employeeId": employeeId, "sickLeave": 12, "casualLeave": 12, "paidLeave": 18};
    }
  }

  Future<Map<String, dynamic>> applyLeave({
    required int employeeId,
    required String leaveType,
    required String fromDate,
    required String toDate,
    required String reason,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final List<Map<String, dynamic>> requests = _storage.getLeaves();

    final int newId = requests.isEmpty 
        ? 1 
        : requests.map((e) => e['leaveId'] as int).reduce(max) + 1;

    final Map<String, dynamic> newRequest = {
      "leaveId": newId,
      "employeeId": employeeId,
      "leaveType": leaveType,
      "fromDate": fromDate,
      "toDate": toDate,
      "reason": reason,
      "status": "Pending",
      "appliedDate": DateTime.now().toUtc().toIso8601String(),
    };

    // Optional: Validation check to see if they have enough balance before applying
    final balance = await getLeaveBalance(employeeId);
    final days = DateTime.parse(toDate).difference(DateTime.parse(fromDate)).inDays + 1;
    
    int currentBal = 0;
    if (leaveType == "Sick Leave") {
      currentBal = balance['sickLeave'] as int;
    } else if (leaveType == "Casual Leave") {
      currentBal = balance['casualLeave'] as int;
    } else if (leaveType == "Paid Leave") {
      currentBal = balance['paidLeave'] as int;
    }

    if (days > currentBal) {
      throw Exception("Insufficient leave balance! Requested: $days, Available: $currentBal");
    }

    requests.add(newRequest);
    await _storage.saveLeaves(requests);
    return newRequest;
  }

  Future<Map<String, dynamic>> approveLeave(int leaveId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final List<Map<String, dynamic>> requests = _storage.getLeaves();
    final index = requests.indexWhere((r) => r['leaveId'] == leaveId);
    if (index == -1) throw Exception("Leave request not found");

    final Map<String, dynamic> request = requests[index];
    if (request['status'] != "Pending") {
      throw Exception("Leave request is already processed: ${request['status']}");
    }

    // Deduct leave balance
    final int employeeId = request['employeeId'] as int;
    final String leaveType = request['leaveType'] as String;
    final String fromDate = request['fromDate'] as String;
    final String toDate = request['toDate'] as String;

    final int days = DateTime.parse(toDate).difference(DateTime.parse(fromDate)).inDays + 1;

    final List<Map<String, dynamic>> balances = _storage.getLeaveBalances();
    final balanceIndex = balances.indexWhere((b) => b['employeeId'] == employeeId);
    
    if (balanceIndex != -1) {
      final Map<String, dynamic> balance = Map<String, dynamic>.from(balances[balanceIndex]);
      if (leaveType == "Sick Leave") {
        balance['sickLeave'] = max(0, (balance['sickLeave'] as int) - days);
      } else if (leaveType == "Casual Leave") {
        balance['casualLeave'] = max(0, (balance['casualLeave'] as int) - days);
      } else if (leaveType == "Paid Leave") {
        balance['paidLeave'] = max(0, (balance['paidLeave'] as int) - days);
      }
      balances[balanceIndex] = balance;
      await _storage.saveLeaveBalances(balances);
    }

    final Map<String, dynamic> updatedRequest = {
      ...request,
      "status": "Approved",
    };

    requests[index] = updatedRequest;
    await _storage.saveLeaves(requests);
    return updatedRequest;
  }

  Future<Map<String, dynamic>> rejectLeave(int leaveId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final List<Map<String, dynamic>> requests = _storage.getLeaves();
    final index = requests.indexWhere((r) => r['leaveId'] == leaveId);
    if (index == -1) throw Exception("Leave request not found");

    final Map<String, dynamic> request = requests[index];
    if (request['status'] != "Pending") {
      throw Exception("Leave request is already processed: ${request['status']}");
    }

    final Map<String, dynamic> updatedRequest = {
      ...request,
      "status": "Rejected",
    };

    requests[index] = updatedRequest;
    await _storage.saveLeaves(requests);
    return updatedRequest;
  }
}
