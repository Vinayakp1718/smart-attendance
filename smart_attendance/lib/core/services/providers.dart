import 'package:flutter_riverpod/flutter_riverpod.dart';

// Services
import 'storage_service.dart';
import 'location_service.dart';
import 'export_service.dart';

// API Services
import '../../data/services/employee_api_service.dart';
import '../../data/services/attendance_api_service.dart';
import '../../data/services/leave_api_service.dart';
import '../../data/services/holiday_api_service.dart';
import '../../data/services/report_api_service.dart';

// Repositories
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/employee_repository.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../../domain/repositories/leave_repository.dart';
import '../../domain/repositories/holiday_repository.dart';
import '../../domain/repositories/report_repository.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/employee_repository_impl.dart';
import '../../data/repositories/attendance_repository_impl.dart';
import '../../data/repositories/leave_repository_impl.dart';
import '../../data/repositories/holiday_repository_impl.dart';
import '../../data/repositories/report_repository_impl.dart';

// Core Services Providers
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('storageService must be initialized in main()');
});

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final exportServiceProvider = Provider<ExportService>((ref) {
  return ExportService();
});

// Mock API Services Providers
final employeeApiServiceProvider = Provider<EmployeeApiService>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return EmployeeApiService(storage);
});

final attendanceApiServiceProvider = Provider<AttendanceApiService>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return AttendanceApiService(storage);
});

final leaveApiServiceProvider = Provider<LeaveApiService>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return LeaveApiService(storage);
});

final holidayApiServiceProvider = Provider<HolidayApiService>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return HolidayApiService(storage);
});

final reportApiServiceProvider = Provider<ReportApiService>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return ReportApiService(storage);
});

// Repositories Providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return AuthRepositoryImpl(storage);
});

final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) {
  return EmployeeRepositoryImpl();
});

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return AttendanceRepositoryImpl();
});

final leaveRepositoryProvider = Provider<LeaveRepository>((ref) {
  return LeaveRepositoryImpl();
});

final holidayRepositoryProvider = Provider<HolidayRepository>((ref) {
  return HolidayRepositoryImpl();
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepositoryImpl();
});
