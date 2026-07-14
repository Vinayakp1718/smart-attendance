import '../entities/leave_request.dart';
import '../entities/leave_balance.dart';

abstract class LeaveRepository {
  Future<List<LeaveRequest>> getLeaveRequests(int employeeId);
  Future<List<LeaveRequest>> getAllLeaveRequests();
  Future<LeaveBalance> getLeaveBalance(int employeeId);
  Future<LeaveRequest> applyLeave({
    required int employeeId,
    required String leaveType,
    required String fromDate,
    required String toDate,
    required String reason,
  });
  Future<LeaveRequest> approveLeave(int leaveId);
  Future<LeaveRequest> recommendLeave(int leaveId);
  Future<LeaveRequest> rejectLeave(int leaveId);
  Future<LeaveBalance> updateLeaveBalance(int employeeId, double sick, double casual, double paid);
}
