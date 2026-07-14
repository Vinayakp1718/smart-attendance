import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/providers.dart';
import '../../domain/entities/role.dart';
import '../../domain/entities/employee.dart';
import '../../features/auth/auth_controller.dart';
import '../../features/employees/employees_controller.dart';
import '../../features/leave/leave_controller.dart';

class LeaveManagementScreen extends ConsumerWidget {
  const LeaveManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(leaveControllerProvider);
    final user = ref.watch(authControllerProvider).user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bool isEmployee = user.role == UserRole.employee;
    final employees = ref.watch(employeesControllerProvider).employees;
    final bool hasSubordinates = employees.any((e) => e.reportingToId == user.employeeId);
    final bool showApprovalTab = !isEmployee || hasSubordinates;

    return DefaultTabController(
      length: showApprovalTab ? 2 : 1,
      child: Scaffold(
        appBar: AppConstants.buildBrandingAppBar(
          context: context,
          title: 'Leave Operations',
          bottom: TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            tabs: [
              const Tab(text: 'My Leaves & Balance', icon: Icon(Icons.date_range)),
              if (showApprovalTab)
                const Tab(text: 'Employee Leave Requests', icon: Icon(Icons.approval_outlined)),
            ],
          ),
        ),
        body: SafeArea(
          child: state.isLoading && state.userRequests.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  children: [
                    _buildMyLeavesTab(context, state, ref, isDark, user),
                    if (showApprovalTab)
                      _buildEmployeeRequestsTab(context, state, ref, isDark),
                  ],
                ),
        ),
      ),
    );
  }

  // ==========================================
  // MY LEAVES TAB
  // ==========================================
  Widget _buildMyLeavesTab(BuildContext context, dynamic state, WidgetRef ref, bool isDark, dynamic user) {
    final balance = state.userBalance;
    final requests = state.userRequests;

    return RefreshIndicator(
      onRefresh: () => ref.read(leaveControllerProvider.notifier).loadLeaveData(),
      child: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // 1. Leave Balances Title
          Text(
            'Available Leave Balances',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Leave Balance Cards Row
          Row(
            children: [
              Expanded(
                child: _buildBalanceCard(
                  context,
                  title: 'Sick Leave',
                  days: balance != null ? formatDays(balance.sickLeave) : '12',
                  maxDays: '12',
                  color: AppConstants.dangerColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildBalanceCard(
                  context,
                  title: 'Casual Leave',
                  days: balance != null ? formatDays(balance.casualLeave) : '12',
                  maxDays: '12',
                  color: AppConstants.warningColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildBalanceCard(
                  context,
                  title: 'Paid Leave',
                  days: balance != null ? formatDays(balance.paidLeave) : '18',
                  maxDays: '18',
                  color: AppConstants.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // 2. Actions Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Leave Requests',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(160, 44),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Apply for Leave'),
                onPressed: () => _showApplyLeaveDialog(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Leave Requests Table / List
          requests.isEmpty
              ? const Card(
                  child: SizedBox(
                    height: 150,
                    child: Center(child: Text('No leave applications submitted yet.')),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: requests.length,
                  itemBuilder: (context, idx) {
                    final req = requests[idx];
                    
                    Color statusColor = AppConstants.warningColor; // Pending
                    if (req.status == 'Approved') statusColor = AppConstants.accentColor;
                    if (req.status == 'Rejected') statusColor = AppConstants.dangerColor;

                    final from = parseFlexibleDate(req.fromDate);
                    final to = parseFlexibleDate(req.toDate);
                    final days = to.difference(from).inDays + 1;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: statusColor.withValues(alpha: 0.1),
                              child: Icon(Icons.beach_access, color: statusColor),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${req.leaveType} (${req.leaveType == 'Half Day Leave' ? '0.5' : days} days)',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Duration: ${req.fromDate} to ${req.toDate}',
                                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                  if (req.reason.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      'Reason: ${req.reason}',
                                      style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 11),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                req.status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(
    BuildContext context, {
    required String title,
    required String days,
    required String maxDays,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  days,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
                ),
                Text(
                  ' / $maxDays Days',
                  style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // EMPLOYEE REQUESTS TAB (HR/Admin)
  // ==========================================
  Widget _buildEmployeeRequestsTab(BuildContext context, dynamic state, WidgetRef ref, bool isDark) {
    final user = ref.watch(authControllerProvider).user;
    if (user == null) return const SizedBox();

    final employees = ref.watch(employeesControllerProvider).employees;
    final bool isHRorAdmin = user.role == UserRole.superAdmin || user.role == UserRole.hrManager;

    final List<dynamic> requests = state.allRequests.where((req) {
      if (isHRorAdmin) {
        return true;
      } else {
        final matches = employees.where((e) => e.employeeId == req.employeeId);
        if (matches.isEmpty) return false;
        final emp = matches.first;
        return emp.reportingToId == user.employeeId;
      }
    }).toList();

    return RefreshIndicator(
      onRefresh: () => ref.read(leaveControllerProvider.notifier).loadLeaveData(),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Leave Applications Waiting Review',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (isHRorAdmin)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 44),
                    ),
                    icon: const Icon(Icons.settings),
                    label: const Text('Manage Yearly Balances'),
                    onPressed: () => _showManageBalancesDialog(context, ref, employees),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: requests.isEmpty
                  ? const Card(
                      child: Center(child: Text('No leave requests pending action.')),
                    )
                  : ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, idx) {
                        final req = requests[idx];
                        final emp = employees.firstWhere(
                          (e) => e.employeeId == req.employeeId,
                          orElse: () => Employee(
                            employeeId: 0,
                            employeeCode: 'EMP0000',
                            firstName: 'Unknown',
                            lastName: 'Employee',
                            email: '',
                            mobileNumber: '',
                            department: '',
                            designation: '',
                            branch: '',
                            joiningDate: DateTime.now(),
                            dateOfBirth: DateTime.now(),
                            address: '',
                            status: false,
                            role: UserRole.employee,
                            createdDate: DateTime.now(),
                          ),
                        );

                        Color statusColor = AppConstants.warningColor;
                        if (req.status == 'Approved') statusColor = AppConstants.accentColor;
                        if (req.status == 'Rejected') statusColor = AppConstants.dangerColor;
                        if (req.status == 'Pending') statusColor = AppConstants.infoColor;

                        final from = parseFlexibleDate(req.fromDate);
                        final to = parseFlexibleDate(req.toDate);
                        final double computedDays = (req.leaveType == 'Half Day Leave') 
                            ? 0.5 
                            : (to.difference(from).inDays + 1).toDouble();

                        final bool canApprove = isHRorAdmin && (req.status == 'Pending' || req.status == 'Pending Recommendation');
                        final bool canRecommend = !isHRorAdmin && emp.reportingToId == user.employeeId && req.status == 'Pending Recommendation';

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: emp.profilePhoto != null ? NetworkImage(emp.profilePhoto!) : null,
                                  child: emp.profilePhoto == null ? Text('${emp.firstName[0]}${emp.lastName[0]}') : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${emp.firstName} ${emp.lastName}',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '(${emp.employeeCode})',
                                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Type: ${req.leaveType} | Duration: ${req.fromDate} to ${req.toDate} (${computedDays == 0.5 ? '0.5' : computedDays.toInt()} days)',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Reason: ${req.reason}',
                                        style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: statusColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        req.status,
                                        style: TextStyle(
                                          color: statusColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    if (canApprove) ...[
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            constraints: const BoxConstraints(),
                                            padding: const EdgeInsets.all(4),
                                            icon: const Icon(Icons.check_circle, color: AppConstants.accentColor, size: 24),
                                            tooltip: 'Approve Request',
                                            onPressed: () => ref.read(leaveControllerProvider.notifier).approveLeave(req.leaveId),
                                          ),
                                          const SizedBox(width: 8),
                                          IconButton(
                                            constraints: const BoxConstraints(),
                                            padding: const EdgeInsets.all(4),
                                            icon: const Icon(Icons.cancel, color: AppConstants.dangerColor, size: 24),
                                            tooltip: 'Reject Request',
                                            onPressed: () => ref.read(leaveControllerProvider.notifier).rejectLeave(req.leaveId),
                                          ),
                                        ],
                                      ),
                                    ],
                                    if (canRecommend) ...[
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            constraints: const BoxConstraints(),
                                            padding: const EdgeInsets.all(4),
                                            icon: const Icon(Icons.thumb_up, color: AppConstants.secondaryColor, size: 22),
                                            tooltip: 'Recommend Request',
                                            onPressed: () => ref.read(leaveControllerProvider.notifier).recommendLeave(req.leaveId),
                                          ),
                                          const SizedBox(width: 8),
                                          IconButton(
                                            constraints: const BoxConstraints(),
                                            padding: const EdgeInsets.all(4),
                                            icon: const Icon(Icons.cancel, color: AppConstants.dangerColor, size: 22),
                                            tooltip: 'Reject Request',
                                            onPressed: () => ref.read(leaveControllerProvider.notifier).rejectLeave(req.leaveId),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // APPLY LEAVE FORM
  // ==========================================
  void _showApplyLeaveDialog(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final reasonController = TextEditingController();
    
    String leaveTypeVal = 'Sick Leave';
    DateTime selectedFromDate = DateTime.now();
    DateTime selectedToDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final double computedDays = (leaveTypeVal == 'Half Day Leave') 
                ? 0.5 
                : (selectedToDate.difference(selectedFromDate).inDays + 1).toDouble();

            return AlertDialog(
              title: const Text('Apply for Leave'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Type Selection
                      DropdownButtonFormField<String>(
                        initialValue: leaveTypeVal,
                        decoration: const InputDecoration(labelText: 'Leave Type'),
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem<String>(value: 'Sick Leave', child: Text('Sick Leave')),
                          DropdownMenuItem<String>(value: 'Casual Leave', child: Text('Casual Leave')),
                          DropdownMenuItem<String>(value: 'Paid Leave', child: Text('Paid Leave')),
                          DropdownMenuItem<String>(value: 'Half Day Leave', child: Text('Half Day Leave')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              leaveTypeVal = val;
                              if (leaveTypeVal == 'Half Day Leave') {
                                selectedToDate = selectedFromDate;
                              }
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Date range selectors
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: selectedFromDate,
                                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (date != null) {
                                  setState(() {
                                    selectedFromDate = date;
                                    if (selectedToDate.isBefore(selectedFromDate) || leaveTypeVal == 'Half Day Leave') {
                                      selectedToDate = selectedFromDate;
                                    }
                                  });
                                }
                              },
                              child: Text(
                                leaveTypeVal == 'Half Day Leave' 
                                    ? 'Date: ${DateFormat('yyyy-MM-dd').format(selectedFromDate)}'
                                    : 'From: ${DateFormat('yyyy-MM-dd').format(selectedFromDate)}', 
                                style: const TextStyle(fontSize: 12)
                              ),
                            ),
                          ),
                          if (leaveTypeVal != 'Half Day Leave') ...[
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: selectedToDate,
                                    firstDate: selectedFromDate,
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                  );
                                  if (date != null) {
                                    setState(() => selectedToDate = date);
                                  }
                                },
                                child: Text('To: ${DateFormat('yyyy-MM-dd').format(selectedToDate)}', style: const TextStyle(fontSize: 12)),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Calculated days summary
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          'Total Duration: ${computedDays == 0.5 ? '0.5 (Half Day)' : computedDays.toInt()} Working Days',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppConstants.primaryColor),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Reason
                      TextFormField(
                        controller: reasonController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Reason for Leave',
                          hintText: 'Provide details...',
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Please describe reason' : null,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    
                    final fromStr = DateFormat('yyyy-MM-dd').format(selectedFromDate);
                    final toStr = DateFormat('yyyy-MM-dd').format(selectedToDate);

                    final success = await ref.read(leaveControllerProvider.notifier).applyLeave(
                      leaveType: leaveTypeVal,
                      fromDate: fromStr,
                      toDate: toStr,
                      reason: reasonController.text,
                    );

                    if (success && context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Leave request applied successfully! Waiting approval.'))
                      );
                    } else {
                      // Error SNACKBAR
                      final errMsg = ref.read(leaveControllerProvider).errorMessage ?? 'Application Failed';
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errMsg), backgroundColor: AppConstants.dangerColor)
                        );
                      }
                    }
                  },
                  child: const Text('Submit Application'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

DateTime parseFlexibleDate(String dateStr) {
  try {
    return DateTime.parse(dateStr);
  } catch (_) {
    final cleaned = dateStr.trim();
    final datePart = cleaned.split(' ')[0];
    final parts = datePart.split('/');
    if (parts.length == 3) {
      final p0 = int.tryParse(parts[0]);
      final p1 = int.tryParse(parts[1]);
      final p2 = int.tryParse(parts[2]);
      if (p0 != null && p1 != null && p2 != null) {
        if (p0 > 12) {
          return DateTime(p2, p1, p0);
        }
        if (p1 > 12) {
          return DateTime(p2, p0, p1);
        }
        return DateTime(p2, p1, p0);
      }
    }
    return DateTime.now();
  }
}

String formatDays(double val) {
  return val % 1 == 0 ? val.toInt().toString() : val.toStringAsFixed(1);
}

void _showManageBalancesDialog(BuildContext context, WidgetRef ref, List<Employee> employees) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Manage Yearly Leave Balances'),
        content: SizedBox(
          width: 500,
          height: 400,
          child: employees.isEmpty
              ? const Center(child: Text('No employees found.'))
              : ListView.separated(
                  itemCount: employees.length,
                  separatorBuilder: (c, i) => const Divider(),
                  itemBuilder: (context, idx) {
                    final emp = employees[idx];
                    
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: emp.profilePhoto != null ? NetworkImage(emp.profilePhoto!) : null,
                        child: emp.profilePhoto == null ? Text('${emp.firstName[0]}${emp.lastName[0]}') : null,
                      ),
                      title: Text('${emp.firstName} ${emp.lastName}'),
                      subtitle: Text('Code: ${emp.employeeCode} | Shift: ${emp.shift}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: AppConstants.primaryColor),
                        tooltip: 'Adjust Leave Balance',
                        onPressed: () {
                          Navigator.pop(context);
                          _showEditBalanceDialog(context, ref, emp);
                        },
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

void _showEditBalanceDialog(BuildContext context, WidgetRef ref, Employee emp) async {
  final repo = ref.read(leaveRepositoryProvider);
  double sickVal = 12.0;
  double casualVal = 12.0;
  double paidVal = 18.0;
  
  try {
    final balance = await repo.getLeaveBalance(emp.employeeId);
    sickVal = balance.sickLeave;
    casualVal = balance.casualLeave;
    paidVal = balance.paidLeave;
  } catch (_) {}

  if (!context.mounted) return;

  final sickController = TextEditingController(text: formatDays(sickVal));
  final casualController = TextEditingController(text: formatDays(casualVal));
  final paidController = TextEditingController(text: formatDays(paidVal));
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Adjust Balance: ${emp.firstName} ${emp.lastName}'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: sickController,
                decoration: const InputDecoration(labelText: 'Sick Leave Limit'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => v == null || double.tryParse(v) == null ? 'Invalid number' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: casualController,
                decoration: const InputDecoration(labelText: 'Casual Leave Limit'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => v == null || double.tryParse(v) == null ? 'Invalid number' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: paidController,
                decoration: const InputDecoration(labelText: 'Paid Leave Limit'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => v == null || double.tryParse(v) == null ? 'Invalid number' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              
              final s = double.parse(sickController.text);
              final c = double.parse(casualController.text);
              final p = double.parse(paidController.text);

              final success = await ref.read(leaveControllerProvider.notifier).updateLeaveBalance(emp.employeeId, s, c, p);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Leave balances updated successfully!'), backgroundColor: AppConstants.accentColor)
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save Bounds'),
          ),
        ],
      );
    },
  );
}
