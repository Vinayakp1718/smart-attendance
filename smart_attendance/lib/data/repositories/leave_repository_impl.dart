import 'package:dio/dio.dart';
import '../../domain/entities/leave_request.dart';
import '../../domain/entities/leave_balance.dart';
import '../../domain/repositories/leave_repository.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:5170/api'));

  @override
  Future<List<LeaveRequest>> getLeaveRequests(int employeeId) async {
    final response = await _dio.get('/leave/requests/$employeeId');
    final list = response.data as List;
    return list.map((e) => LeaveRequest.fromJson(e)).toList();
  }

  @override
  Future<List<LeaveRequest>> getAllLeaveRequests() async {
    final response = await _dio.get('/leave/requests');
    final list = response.data as List;
    return list.map((e) => LeaveRequest.fromJson(e)).toList();
  }

  @override
  Future<LeaveBalance> getLeaveBalance(int employeeId) async {
    final response = await _dio.get('/leave/balance/$employeeId');
    return LeaveBalance.fromJson(response.data);
  }

  @override
  Future<LeaveRequest> applyLeave({
    required int employeeId,
    required String leaveType,
    required String fromDate,
    required String toDate,
    required String reason,
  }) async {
    final response = await _dio.post('/leave/apply', data: {
      'employeeId': employeeId,
      'leaveType': leaveType,
      'fromDate': fromDate,
      'toDate': toDate,
      'reason': reason,
    });
    return LeaveRequest.fromJson(response.data);
  }

  @override
  Future<LeaveRequest> approveLeave(int leaveId) async {
    final response = await _dio.post('/leave/$leaveId/approve');
    return LeaveRequest.fromJson(response.data);
  }

  @override
  Future<LeaveRequest> recommendLeave(int leaveId) async {
    final response = await _dio.post('/leave/$leaveId/recommend');
    return LeaveRequest.fromJson(response.data);
  }

  @override
  Future<LeaveRequest> rejectLeave(int leaveId) async {
    final response = await _dio.post('/leave/$leaveId/reject');
    return LeaveRequest.fromJson(response.data);
  }

  @override
  Future<LeaveBalance> updateLeaveBalance(int employeeId, double sick, double casual, double paid) async {
    final response = await _dio.put('/leave/balance/$employeeId', data: {
      'employeeId': employeeId,
      'sickLeave': sick,
      'casualLeave': casual,
      'paidLeave': paid,
    });
    return LeaveBalance.fromJson(response.data);
  }
}
