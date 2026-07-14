import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:convert';
import '../../core/constants/app_constants.dart';
import '../../features/reports/reports_controller.dart';
import '../../features/employees/employees_controller.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();
  int? _selectedEmployeeId;
  String? _selectedDept;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    // Load initial reports on mount
    _fetchData();
  }

  void _fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reportsControllerProvider.notifier).fetchAttendanceReport(
            startDate: DateFormat('yyyy-MM-dd').format(_startDate),
            endDate: DateFormat('yyyy-MM-dd').format(_endDate),
            employeeId: _selectedEmployeeId,
            department: _selectedDept,
            status: _selectedStatus,
          );
    });
  }

  void _exportCSVWeb(BuildContext context) {
    final state = ref.read(reportsControllerProvider);
    if (state.attendanceReports.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No data to export! Please run a report query first.'))
      );
      return;
    }

    final String title = 'Attendance_Report_${DateFormat('yyyyMMdd').format(_startDate)}_to_${DateFormat('yyyyMMdd').format(_endDate)}';
    final List<String> headers = ['Date', 'Code', 'Employee Name', 'Department', 'Designation', 'Status', 'In', 'Out', 'Hours Worked'];
    
    final List<List<String>> rows = state.attendanceReports.map<List<String>>((log) {
      final inStr = log['checkInTime'] != null
          ? DateTime.parse(log['checkInTime']).toLocal().toString().substring(11, 16)
          : '--:--';
      final outStr = log['checkOutTime'] != null
          ? DateTime.parse(log['checkOutTime']).toLocal().toString().substring(11, 16)
          : '--:--';
      
      return [
        log['attendanceDate']?.toString() ?? '',
        log['employeeCode']?.toString() ?? '',
        '${log['firstName']} ${log['lastName']}',
        log['department']?.toString() ?? '',
        log['designation']?.toString() ?? '',
        log['status']?.toString() ?? '',
        inStr,
        outStr,
        '${log['workingHours'] ?? 0.0} hrs',
      ];
    }).toList();

    final buffer = StringBuffer();
    buffer.writeln(headers.join(','));
    for (final row in rows) {
      buffer.writeln(row.map((field) => '"${field.replaceAll('"', '""')}"').join(','));
    }
    
    final csvContent = buffer.toString();
    final bytes = utf8.encode(csvContent);
    final blob = html.Blob([bytes], 'text/csv');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = '$title.csv';
    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('CSV Report downloaded successfully!'), backgroundColor: AppConstants.accentColor)
    );
  }

  void _triggerExport(BuildContext context, bool isExcel) async {
    final state = ref.read(reportsControllerProvider);
    if (state.attendanceReports.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No data to export! Please run a report query first.'))
      );
      return;
    }

    final String title = 'Attendance_Report_${DateFormat('yyyyMMdd').format(_startDate)}_to_${DateFormat('yyyyMMdd').format(_endDate)}';
    final List<String> headers = ['Date', 'Code', 'Employee Name', 'Department', 'Designation', 'Status', 'In', 'Out', 'Hours Worked'];
    
    final List<List<String>> rows = state.attendanceReports.map<List<String>>((log) {
      final inStr = log['checkInTime'] != null
          ? DateTime.parse(log['checkInTime']).toLocal().toString().substring(11, 16)
          : '--:--';
      final outStr = log['checkOutTime'] != null
          ? DateTime.parse(log['checkOutTime']).toLocal().toString().substring(11, 16)
          : '--:--';
      
      return [
        log['attendanceDate']?.toString() ?? '',
        log['employeeCode']?.toString() ?? '',
        '${log['firstName']} ${log['lastName']}',
        log['department']?.toString() ?? '',
        log['designation']?.toString() ?? '',
        log['status']?.toString() ?? '',
        inStr,
        outStr,
        '${log['workingHours'] ?? 0.0} hrs',
      ];
    }).toList();

    bool success;
    if (isExcel) {
      success = await ref.read(reportsControllerProvider.notifier).exportExcel(
            title: title.replaceAll('_', ' '),
            headers: headers,
            rows: rows,
          );
    } else {
      success = await ref.read(reportsControllerProvider.notifier).exportPdf(
            title: title.replaceAll('_', ' '),
            headers: headers,
            rows: rows,
          );
    }

    if (success && context.mounted) {
      final path = ref.read(reportsControllerProvider).exportPath ?? '';
      _showExportSuccessDialog(context, path);
    } else {
      final errMsg = ref.read(reportsControllerProvider).errorMessage ?? 'Export failed';
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errMsg), backgroundColor: AppConstants.dangerColor)
        );
      }
    }
  }

  void _showExportSuccessDialog(BuildContext context, String path) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: AppConstants.accentColor),
              SizedBox(width: 12),
              Text('Export Successful'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('The report document has been generated and saved locally:'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  path,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ],
          ),
          actions: [
            OutlinedButton.icon(
              icon: const Icon(Icons.copy),
              label: const Text('Copy File Path'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: path));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('File path copied to clipboard!'))
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ref.read(reportsControllerProvider.notifier).clearExportPath();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final reportState = ref.watch(reportsControllerProvider);
    final employeeState = ref.watch(employeesControllerProvider);

    return Scaffold(
      appBar: AppConstants.buildBrandingAppBar(
        context: context,
        title: 'Reporting Workspace',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Filters Card Panel
              Card(
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          // Date range button
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(260, 44),
                            ),
                            icon: const Icon(Icons.date_range),
                            label: Text(
                              'Date Range: ${DateFormat('yyyy-MM-dd').format(_startDate)} to ${DateFormat('yyyy-MM-dd').format(_endDate)}',
                            ),
                            onPressed: () async {
                              final range = await showDateRangePicker(
                                context: context,
                                firstDate: DateTime(2025),
                                lastDate: DateTime.now(),
                                initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
                              );
                              if (range != null) {
                                setState(() {
                                  _startDate = range.start;
                                  _endDate = range.end;
                                });
                              }
                            },
                          ),
                          
                          // Employee Dropdown lookup
                          DropdownButton<int>(
                            value: _selectedEmployeeId,
                            hint: const Text('All Employees'),
                            onChanged: (val) => setState(() => _selectedEmployeeId = val),
                            items: <DropdownMenuItem<int>>[
                              const DropdownMenuItem<int>(value: null, child: Text('All Employees')),
                              ...employeeState.employees.map((e) {
                                return DropdownMenuItem<int>(value: e.employeeId, child: Text('${e.firstName} ${e.lastName} (${e.employeeCode})'));
                              }),
                            ],
                          ),

                          // Dept dropdown
                          DropdownButton<String>(
                            value: _selectedDept,
                            hint: const Text('All Departments'),
                            onChanged: (val) => setState(() => _selectedDept = val),
                            items: <DropdownMenuItem<String>>[
                              const DropdownMenuItem<String>(value: null, child: Text('All Departments')),
                              ...employeeState.departments.map((d) {
                                return DropdownMenuItem<String>(value: d.name, child: Text(d.name));
                              }),
                            ],
                          ),

                          // Status dropdown
                          DropdownButton<String>(
                            value: _selectedStatus,
                            hint: const Text('All Status'),
                            onChanged: (val) => setState(() => _selectedStatus = val),
                            items: const <DropdownMenuItem<String>>[
                              DropdownMenuItem<String>(value: null, child: Text('All Status')),
                              DropdownMenuItem<String>(value: 'Present', child: Text('Present')),
                              DropdownMenuItem<String>(value: 'Late', child: Text('Late')),
                              DropdownMenuItem<String>(value: 'Half Day', child: Text('Half Day')),
                              DropdownMenuItem<String>(value: 'Absent', child: Text('Absent')),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Submit and Export Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(minimumSize: const Size(180, 48)),
                            icon: const Icon(Icons.analytics),
                            label: const Text('Generate Report'),
                            onPressed: _fetchData,
                          ),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(130, 44),
                                ),
                                icon: const Icon(Icons.table_view, color: Colors.green),
                                label: const Text('Export Excel'),
                                onPressed: () => _triggerExport(context, true),
                              ),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(130, 44),
                                ),
                                icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                                label: const Text('Export PDF'),
                                onPressed: () => _triggerExport(context, false),
                              ),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(130, 44),
                                ),
                                icon: const Icon(Icons.download, color: Colors.teal),
                                label: const Text('Export CSV'),
                                onPressed: () => _exportCSVWeb(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Data Results Table
              Expanded(
                child: Card(
                  child: reportState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : reportState.attendanceReports.isEmpty
                          ? const Center(child: Text('No attendance logs found matching filters. Click Generate Report.'))
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                child: DataTable(
                                  columns: const [
                                    DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Emp Code', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Employee Name', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Department', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Designation', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Check In', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Check Out', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Working Hours', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                                  ],
                                  rows: reportState.attendanceReports.map<DataRow>((log) {
                                    final checkInStr = log['checkInTime'] != null
                                        ? DateTime.parse(log['checkInTime']).toLocal().toString().substring(11, 16)
                                        : '--:--';
                                    final checkOutStr = log['checkOutTime'] != null
                                        ? DateTime.parse(log['checkOutTime']).toLocal().toString().substring(11, 16)
                                        : '--:--';

                                    Color statusColor = AppConstants.primaryColor;
                                    if (log['status'] == 'Present') statusColor = AppConstants.accentColor;
                                    if (log['status'] == 'Late') statusColor = AppConstants.warningColor;
                                    if (log['status'] == 'Half Day') statusColor = AppConstants.infoColor;
                                    if (log['status'] == 'Absent') statusColor = AppConstants.dangerColor;

                                    return DataRow(
                                      cells: [
                                        DataCell(Text(log['attendanceDate'] ?? '')),
                                        DataCell(Text(log['employeeCode'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600))),
                                        DataCell(Text('${log['firstName']} ${log['lastName']}')),
                                        DataCell(Text(log['department'] ?? '')),
                                        DataCell(Text(log['designation'] ?? '')),
                                        DataCell(Text(checkInStr)),
                                        DataCell(Text(checkOutStr)),
                                        DataCell(Text('${log['workingHours'] ?? 0.0} hrs')),
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: statusColor.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              log['status'] ?? '',
                                              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
