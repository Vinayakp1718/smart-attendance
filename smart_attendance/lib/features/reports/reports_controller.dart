import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/providers.dart';
import 'reports_state.dart';

class ReportsController extends StateNotifier<ReportsState> {
  final Ref _ref;

  ReportsController(this._ref) : super(const ReportsState());

  void clearExportPath() {
    state = state.copyWith(clearExportPath: true);
  }

  Future<void> fetchAttendanceReport({
    String? startDate,
    String? endDate,
    int? employeeId,
    String? department,
    String? status,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null, clearExportPath: true);
    try {
      final repo = _ref.read(reportRepositoryProvider);
      final data = await repo.getFilteredAttendance(
        startDate: startDate,
        endDate: endDate,
        employeeId: employeeId,
        department: department,
        status: status,
      );
      
      // Sort reports by date descending, then employee code
      data.sort((a, b) {
        final cmp = b['attendanceDate'].toString().compareTo(a['attendanceDate'].toString());
        if (cmp != 0) return cmp;
        return a['employeeCode'].toString().compareTo(b['employeeCode'].toString());
      });

      state = state.copyWith(
        attendanceReports: data,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> fetchPayrollSummary({
    required int month,
    required int year,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null, clearExportPath: true);
    try {
      final repo = _ref.read(reportRepositoryProvider);
      final data = await repo.getPayrollSummary(month: month, year: year);

      state = state.copyWith(
        payrollSummary: data,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<bool> exportExcel({
    required String title,
    required List<String> headers,
    required List<List<String>> rows,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null, clearExportPath: true);
    try {
      final exporter = _ref.read(exportServiceProvider);
      final path = await exporter.exportAttendanceToExcel(
        title: title,
        headers: headers,
        rows: rows,
      );
      state = state.copyWith(exportPath: path, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> exportPdf({
    required String title,
    required List<String> headers,
    required List<List<String>> rows,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null, clearExportPath: true);
    try {
      final exporter = _ref.read(exportServiceProvider);
      final path = await exporter.exportAttendanceToPdf(
        title: title,
        headers: headers,
        rows: rows,
      );
      state = state.copyWith(exportPath: path, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }
}

final reportsControllerProvider = StateNotifierProvider<ReportsController, ReportsState>((ref) {
  return ReportsController(ref);
});
