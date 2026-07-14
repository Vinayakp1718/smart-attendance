import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:convert';
import '../../core/constants/app_constants.dart';
import '../../features/reports/reports_controller.dart';

class PayrollScreen extends ConsumerStatefulWidget {
  const PayrollScreen({super.key});

  @override
  ConsumerState<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends ConsumerState<PayrollScreen> {
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _fetchSummary();
  }

  void _exportCSVWeb(BuildContext context) {
    final state = ref.read(reportsControllerProvider);
    if (state.payrollSummary.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No data to export! Please calculate summaries first.'))
      );
      return;
    }

    final String title = 'Payroll_Ledger_${_months[_selectedMonth - 1]}_$_selectedYear';
    final List<String> headers = ['Employee Code', 'Employee Name', 'Department', 'Designation', 'Month/Year', 'Present Days', 'Absent Days', 'Leave Days', 'Working Days', 'Total Days'];
    
    final List<List<String>> rows = state.payrollSummary.map<List<String>>((p) {
      return [
        p['employeeCode']?.toString() ?? '',
        '${p['firstName']} ${p['lastName']}',
        p['department']?.toString() ?? '',
        p['designation']?.toString() ?? '',
        '${_months[p['month'] - 1]} ${p['year']}',
        p['presentDays']?.toString() ?? '0',
        p['absentDays']?.toString() ?? '0',
        p['leaveDays']?.toString() ?? '0',
        p['workingDays']?.toString() ?? '0',
        p['totalDays']?.toString() ?? '30',
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
      const SnackBar(content: Text('Payroll Ledger downloaded successfully!'), backgroundColor: AppConstants.accentColor)
    );
  }

  void _fetchSummary() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reportsControllerProvider.notifier).fetchPayrollSummary(
            month: _selectedMonth,
            year: _selectedYear,
          );
    });
  }

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reportsControllerProvider);

    return Scaffold(
      appBar: AppConstants.buildBrandingAppBar(
        context: context,
        title: 'Payroll Summary Ledger',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Filters Card
              Card(
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // Month drop
                      DropdownButton<int>(
                        value: _selectedMonth,
                        items: List.generate(12, (index) {
                          return DropdownMenuItem<int>(
                            value: index + 1,
                            child: Text(_months[index]),
                          );
                        }),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedMonth = val);
                        },
                      ),

                      // Year drop
                      DropdownButton<int>(
                        value: _selectedYear,
                        items: [2025, 2026, 2027, 2028].map((y) {
                          return DropdownMenuItem<int>(
                            value: y,
                            child: Text('$y'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedYear = val);
                        },
                      ),

                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(minimumSize: const Size(180, 48)),
                        icon: const Icon(Icons.calculate_outlined),
                        label: const Text('Calculate Summaries'),
                        onPressed: _fetchSummary,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(180, 48),
                          backgroundColor: Colors.teal,
                        ),
                        icon: const Icon(Icons.download),
                        label: const Text('Export to CSV'),
                        onPressed: () => _exportCSVWeb(context),
                      ),
                    ],
                  ),
                ),
              ),

              // Ledger Table
              Expanded(
                child: Card(
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state.payrollSummary.isEmpty
                          ? const Center(child: Text('No payroll data generated. Click Calculate.'))
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                child: DataTable(
                                  columns: const [
                                    DataColumn(label: Text('Employee Code', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Employee Name', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Department', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Designation', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Month/Year', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Present Days', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Absent Days', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Leave Days', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Working Days', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Total Days', style: TextStyle(fontWeight: FontWeight.bold))),
                                  ],
                                  rows: state.payrollSummary.map<DataRow>((p) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(p['employeeCode'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600))),
                                        DataCell(Text('${p['firstName']} ${p['lastName']}')),
                                        DataCell(Text(p['department'] ?? '')),
                                        DataCell(Text(p['designation'] ?? '')),
                                        DataCell(Text('${_months[p['month'] - 1]} ${p['year']}')),
                                        DataCell(Text('${p['presentDays']}', style: const TextStyle(color: AppConstants.accentColor, fontWeight: FontWeight.bold))),
                                        DataCell(Text('${p['absentDays']}', style: const TextStyle(color: AppConstants.dangerColor, fontWeight: FontWeight.bold))),
                                        DataCell(Text('${p['leaveDays']}', style: const TextStyle(color: AppConstants.warningColor, fontWeight: FontWeight.bold))),
                                        DataCell(Text('${p['workingDays']}')),
                                        DataCell(Text('${p['totalDays']}')),
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
