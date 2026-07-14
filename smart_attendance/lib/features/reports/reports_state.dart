class ReportsState {
  final List<Map<String, dynamic>> attendanceReports;
  final List<Map<String, dynamic>> payrollSummary;
  final bool isLoading;
  final String? errorMessage;
  final String? exportPath;

  const ReportsState({
    this.attendanceReports = const [],
    this.payrollSummary = const [],
    this.isLoading = false,
    this.errorMessage,
    this.exportPath,
  });

  ReportsState copyWith({
    List<Map<String, dynamic>>? attendanceReports,
    List<Map<String, dynamic>>? payrollSummary,
    bool? isLoading,
    String? errorMessage,
    String? exportPath,
    bool clearExportPath = false,
  }) {
    return ReportsState(
      attendanceReports: attendanceReports ?? this.attendanceReports,
      payrollSummary: payrollSummary ?? this.payrollSummary,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      exportPath: clearExportPath ? null : (exportPath ?? this.exportPath),
    );
  }
}
