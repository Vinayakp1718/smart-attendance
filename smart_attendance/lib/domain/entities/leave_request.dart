import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_request.freezed.dart';
part 'leave_request.g.dart';

@freezed
class LeaveRequest with _$LeaveRequest {
  const factory LeaveRequest({
    required int leaveId,
    required int employeeId,
    required String leaveType, // Sick Leave, Casual Leave, Paid Leave
    required String fromDate, // YYYY-MM-DD
    required String toDate,   // YYYY-MM-DD
    required String reason,
    required String status, // Pending, Approved, Rejected
    required DateTime appliedDate,
  }) = _LeaveRequest;

  factory LeaveRequest.fromJson(Map<String, dynamic> json) => _$LeaveRequestFromJson(json);
}
