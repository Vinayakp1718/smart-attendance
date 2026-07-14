import '../../domain/entities/attendance.dart';

class AttendanceState {
  final Attendance? todayRecord;
  final List<Attendance> history;
  final bool isLoading;
  final String? errorMessage;
  
  // GPS Geolocation fields
  final double? latitude;
  final double? longitude;
  final double? distanceToOffice;
  final bool isWithinGeofence;

  const AttendanceState({
    this.todayRecord,
    this.history = const [],
    this.isLoading = false,
    this.errorMessage,
    this.latitude,
    this.longitude,
    this.distanceToOffice,
    this.isWithinGeofence = false,
  });

  bool get isCheckedIn => todayRecord != null;
  bool get isCheckedOut => todayRecord?.checkOutTime != null;
  bool get isOnBreak => todayRecord?.breakStartTime != null && todayRecord?.breakEndTime == null;

  AttendanceState copyWith({
    Attendance? todayRecord,
    List<Attendance>? history,
    bool? isLoading,
    String? errorMessage,
    double? latitude,
    double? longitude,
    double? distanceToOffice,
    bool? isWithinGeofence,
    bool clearTodayRecord = false,
  }) {
    return AttendanceState(
      todayRecord: clearTodayRecord ? null : (todayRecord ?? this.todayRecord),
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distanceToOffice: distanceToOffice ?? this.distanceToOffice,
      isWithinGeofence: isWithinGeofence ?? this.isWithinGeofence,
    );
  }
}
