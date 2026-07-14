import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/providers.dart';
import '../auth/auth_controller.dart';
import 'attendance_state.dart';

class AttendanceController extends StateNotifier<AttendanceState> {
  final Ref _ref;

  AttendanceController(this._ref) : super(const AttendanceState()) {
    // Reload logs whenever auth state changes (e.g. login/logout)
    _ref.listen(authControllerProvider, (previous, next) {
      if (next.user != null) {
        loadEmployeeAttendance(next.user!.employeeId);
      } else {
        state = const AttendanceState(); // Clear state on logout
      }
    });

    final currentUser = _ref.read(authControllerProvider).user;
    if (currentUser != null) {
      loadEmployeeAttendance(currentUser.employeeId);
    }
  }

  Future<void> loadEmployeeAttendance(int employeeId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(attendanceRepositoryProvider);
      final todayRec = await repo.getTodayAttendance(employeeId);
      final historyList = await repo.getAttendanceHistory(employeeId);

      // Sort history descending by date
      historyList.sort((a, b) => b.attendanceDate.compareTo(a.attendanceDate));

      state = state.copyWith(
        todayRecord: todayRec,
        history: historyList,
        isLoading: false,
        clearTodayRecord: todayRec == null,
      );
      
      // Automatically refresh GPS state
      await refreshGpsLocation();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> refreshGpsLocation() async {
    try {
      final locationService = _ref.read(locationServiceProvider);
      final position = await locationService.getCurrentLocation();
      final double distance = locationService.calculateDistanceToOffice(
        position.latitude,
        position.longitude,
      );
      final bool inside = locationService.isWithinOfficeGeofence(
        position.latitude,
        position.longitude,
      );

      state = state.copyWith(
        latitude: position.latitude,
        longitude: position.longitude,
        distanceToOffice: distance,
        isWithinGeofence: inside,
      );
    } catch (_) {
      // Keep previous coords or use mock defaults from location service
    }
  }

  Future<bool> punchIn(String locationType) async {
    final user = _ref.read(authControllerProvider).user;
    if (user == null) {
      state = state.copyWith(errorMessage: "No user logged in.");
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // 1. Get latest GPS coordinates
      await refreshGpsLocation();
      
      final lat = state.latitude ?? 18.5204;
      final lon = state.longitude ?? 73.8567;

      // 2. Register Check In (Geofence is computed for analytics, but does not block WFH/Client)
      final repo = _ref.read(attendanceRepositoryProvider);
      await repo.checkIn(user.employeeId, lat, lon, locationType: locationType);

      // 3. Reload data
      await loadEmployeeAttendance(user.employeeId);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> punchOut() async {
    final user = _ref.read(authControllerProvider).user;
    if (user == null) return false;

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(attendanceRepositoryProvider);
      await repo.checkOut(user.employeeId);
      await loadEmployeeAttendance(user.employeeId);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> toggleBreak() async {
    final user = _ref.read(authControllerProvider).user;
    if (user == null) return false;

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(attendanceRepositoryProvider);
      if (state.isOnBreak) {
        await repo.endBreak(user.employeeId);
      } else {
        await repo.startBreak(user.employeeId);
      }
      await loadEmployeeAttendance(user.employeeId);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }
}

final attendanceControllerProvider = StateNotifierProvider<AttendanceController, AttendanceState>((ref) {
  return AttendanceController(ref);
});
