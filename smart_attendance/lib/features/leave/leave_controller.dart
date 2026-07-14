import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/providers.dart';
import '../../domain/entities/leave_request.dart';
import '../auth/auth_controller.dart';
import 'leave_state.dart';

class LeaveController extends StateNotifier<LeaveState> {
  final Ref _ref;

  LeaveController(this._ref) : super(const LeaveState()) {
    // Reload logs whenever auth state changes (e.g. login/logout)
    _ref.listen(authControllerProvider, (previous, next) {
      if (next.user != null) {
        loadLeaveData();
      } else {
        state = const LeaveState(); // Clear state on logout
      }
    });

    final currentUser = _ref.read(authControllerProvider).user;
    if (currentUser != null) {
      loadLeaveData();
    }
  }

  Future<void> loadLeaveData() async {
    final user = _ref.read(authControllerProvider).user;
    if (user == null) return;

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(leaveRepositoryProvider);
      
      // Load user-specific balance and requests
      final balance = await repo.getLeaveBalance(user.employeeId);
      final userReqs = await repo.getLeaveRequests(user.employeeId);
      userReqs.sort((LeaveRequest a, LeaveRequest b) => b.appliedDate.compareTo(a.appliedDate));

      List<LeaveRequest> allReqs = [];
      // Load ALL requests so managers/team leaders can recommend leaves
      allReqs = await repo.getAllLeaveRequests();
      allReqs.sort((LeaveRequest a, LeaveRequest b) => b.appliedDate.compareTo(a.appliedDate));

      state = state.copyWith(
        userBalance: balance,
        userRequests: userReqs,
        allRequests: allReqs,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<bool> applyLeave({
    required String leaveType,
    required String fromDate,
    required String toDate,
    required String reason,
  }) async {
    final user = _ref.read(authControllerProvider).user;
    if (user == null) return false;

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(leaveRepositoryProvider);
      await repo.applyLeave(
        employeeId: user.employeeId,
        leaveType: leaveType,
        fromDate: fromDate,
        toDate: toDate,
        reason: reason,
      );
      await loadLeaveData();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> approveLeave(int leaveId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(leaveRepositoryProvider);
      await repo.approveLeave(leaveId);
      await loadLeaveData();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> recommendLeave(int leaveId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(leaveRepositoryProvider);
      await repo.recommendLeave(leaveId);
      await loadLeaveData();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> rejectLeave(int leaveId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(leaveRepositoryProvider);
      await repo.rejectLeave(leaveId);
      await loadLeaveData();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> updateLeaveBalance(int employeeId, double sick, double casual, double paid) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(leaveRepositoryProvider);
      await repo.updateLeaveBalance(employeeId, sick, casual, paid);
      await loadLeaveData();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }
}

final leaveControllerProvider = StateNotifierProvider<LeaveController, LeaveState>((ref) {
  return LeaveController(ref);
});
