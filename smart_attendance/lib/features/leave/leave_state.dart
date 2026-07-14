import '../../domain/entities/leave_request.dart';
import '../../domain/entities/leave_balance.dart';

class LeaveState {
  final List<LeaveRequest> userRequests;
  final List<LeaveRequest> allRequests;
  final LeaveBalance? userBalance;
  final bool isLoading;
  final String? errorMessage;

  const LeaveState({
    this.userRequests = const [],
    this.allRequests = const [],
    this.userBalance,
    this.isLoading = false,
    this.errorMessage,
  });

  LeaveState copyWith({
    List<LeaveRequest>? userRequests,
    List<LeaveRequest>? allRequests,
    LeaveBalance? userBalance,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LeaveState(
      userRequests: userRequests ?? this.userRequests,
      allRequests: allRequests ?? this.allRequests,
      userBalance: userBalance ?? this.userBalance,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
