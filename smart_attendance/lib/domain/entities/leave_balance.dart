import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_balance.freezed.dart';
part 'leave_balance.g.dart';

@freezed
class LeaveBalance with _$LeaveBalance {
  const factory LeaveBalance({
    required int employeeId,
    required double sickLeave,
    required double casualLeave,
    required double paidLeave,
  }) = _LeaveBalance;

  factory LeaveBalance.fromJson(Map<String, dynamic> json) => _$LeaveBalanceFromJson(json);
}
