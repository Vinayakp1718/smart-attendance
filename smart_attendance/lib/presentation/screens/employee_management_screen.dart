import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/employee.dart';
import '../../domain/entities/role.dart';
import '../../features/employees/employees_controller.dart';

class EmployeeManagementScreen extends ConsumerStatefulWidget {
  const EmployeeManagementScreen({super.key});

  @override
  ConsumerState<EmployeeManagementScreen> createState() => _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends ConsumerState<EmployeeManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(employeesControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppConstants.buildBrandingAppBar(
          context: context,
          title: 'People & Hierarchy',
          bottom: const TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            tabs: [
              Tab(text: 'Employee Directory', icon: Icon(Icons.people_outline)),
              Tab(text: 'Departments', icon: Icon(Icons.business_outlined)),
              Tab(text: 'Designations', icon: Icon(Icons.badge_outlined)),
              Tab(text: 'Branches', icon: Icon(Icons.location_on_outlined)),
            ],
          ),
        ),
        body: SafeArea(
          child: state.isLoading && state.departments.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : state.errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.cloud_off_outlined, size: 60, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              'Failed to connect to API: ${state.errorMessage}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(200, 48),
                              ),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry Connection'),
                              onPressed: () => ref.read(employeesControllerProvider.notifier).loadAllData(),
                            ),
                          ],
                        ),
                      ),
                    )
                  : TabBarView(
                      children: [
                        _buildEmployeeDirectoryTab(context, state, isDark),
                        _buildDepartmentsTab(context, state, isDark),
                        _buildDesignationsTab(context, state, isDark),
                        _buildBranchesTab(context, state, isDark),
                      ],
                    ),
        ),
      ),
    );
  }

  // ==========================================
  // EMPLOYEE DIRECTORY TAB
  // ==========================================

  Widget _buildEmployeeDirectoryTab(BuildContext context, dynamic state, bool isDark) {
    final employees = state.filteredEmployees;
    final isMobile = MediaQuery.of(context).size.width < 900;
    
    final searchCard = Card(
      margin: EdgeInsets.only(bottom: isMobile ? 12 : 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Search box
            SizedBox(
              width: isMobile ? double.infinity : 300,
              child: TextField(
                controller: _searchController,
                onChanged: (val) => ref.read(employeesControllerProvider.notifier).updateSearchQuery(val),
                decoration: InputDecoration(
                  hintText: 'Search by code, name or email...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(employeesControllerProvider.notifier).updateSearchQuery('');
                          },
                        )
                      : null,
                ),
              ),
            ),
            
            // Filters Wrap
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // Department Filter
                DropdownButton<String>(
                  value: state.selectedDepartment,
                  hint: const Text('All Departments'),
                  onChanged: (val) => ref.read(employeesControllerProvider.notifier).updateDepartmentFilter(val),
                  items: <DropdownMenuItem<String>>[
                    const DropdownMenuItem<String>(value: null, child: Text('All Departments')),
                    ...state.departments.map((dept) {
                      return DropdownMenuItem<String>(value: dept.name, child: Text(dept.name));
                    }),
                  ],
                ),
                // Branch Filter
                DropdownButton<String>(
                  value: state.selectedBranch,
                  hint: const Text('All Branches'),
                  onChanged: (val) => ref.read(employeesControllerProvider.notifier).updateBranchFilter(val),
                  items: <DropdownMenuItem<String>>[
                    const DropdownMenuItem<String>(value: null, child: Text('All Branches')),
                    ...state.branches.map((br) {
                      return DropdownMenuItem<String>(value: br.name, child: Text(br.name));
                    }),
                  ],
                ),
                // Status Filter
                DropdownButton<bool>(
                  value: state.selectedStatus,
                  hint: const Text('All Status'),
                  onChanged: (val) => ref.read(employeesControllerProvider.notifier).updateStatusFilter(val),
                  items: const <DropdownMenuItem<bool>>[
                    DropdownMenuItem<bool>(value: null, child: Text('All Status')),
                    DropdownMenuItem<bool>(value: true, child: Text('Active')),
                    DropdownMenuItem<bool>(value: false, child: Text('Inactive')),
                  ],
                ),
                // Clear button
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(120, 44),
                  ),
                  icon: const Icon(Icons.filter_alt_off),
                  label: const Text('Clear'),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(employeesControllerProvider.notifier).clearFilters();
                  },
                ),
              ],
            ),
            
            // Add Employee Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(minimumSize: const Size(180, 48)),
              icon: const Icon(Icons.add),
              label: const Text('Add Employee'),
              onPressed: () => _showEmployeeFormDialog(context, null),
            ),
          ],
        ),
      ),
    );

    final tableCard = Card(
      child: state.isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            )
          : employees.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Text('No employees found match current search query.'),
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Employee Code', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Role', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Department', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Designation', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: employees.map<DataRow>((emp) {
                        return DataRow(
                          cells: [
                            DataCell(Text(emp.employeeCode, style: const TextStyle(fontWeight: FontWeight.w600))),
                            DataCell(Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundImage: emp.profilePhoto != null
                                      ? NetworkImage(emp.profilePhoto!)
                                      : null,
                                  child: emp.profilePhoto == null
                                      ? Text('${emp.firstName[0]}${emp.lastName[0]}', style: const TextStyle(fontSize: 10))
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                Text('${emp.firstName} ${emp.lastName}'),
                              ],
                            )),
                            DataCell(Text(emp.email)),
                            DataCell(Text(emp.role.displayName)),
                            DataCell(Text(emp.department)),
                            DataCell(Text(emp.designation)),
                            DataCell(
                              Switch(
                                value: emp.status,
                                activeThumbColor: AppConstants.accentColor,
                                onChanged: (val) {
                                  ref.read(employeesControllerProvider.notifier).toggleEmployeeStatus(emp.employeeId);
                                },
                              ),
                            ),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_red_eye_outlined, color: Colors.blue),
                                  onPressed: () => _showEmployeeDetailsDialog(context, emp),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, color: Colors.amber),
                                  onPressed: () => _showEmployeeFormDialog(context, emp),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: AppConstants.dangerColor),
                                  onPressed: () => _confirmDeleteEmployee(context, emp),
                                ),
                              ],
                            )),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
    );

    return Padding(
      padding: EdgeInsets.all(isMobile ? 12.0 : 24.0),
      child: isMobile
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  searchCard,
                  const SizedBox(height: 12),
                  tableCard,
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                searchCard,
                Expanded(child: tableCard),
              ],
            ),
    );
  }

  // ==========================================
  // DEPARTMENTS TAB
  // ==========================================
  Widget _buildDepartmentsTab(BuildContext context, dynamic state, bool isDark) {
    final depts = state.departments;
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Available Departments', style: Theme.of(context).textTheme.titleLarge),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(165, 44),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Add Department'),
                onPressed: () => _showDepartmentFormDialog(context, null),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: depts.isEmpty
                ? const Center(child: Text('No departments added yet.'))
                : ListView.builder(
                    itemCount: depts.length,
                    itemBuilder: (context, idx) {
                      final dept = depts[idx];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              const CircleAvatar(child: Icon(Icons.business)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(dept.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text('Code: ${dept.code}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: Colors.amber),
                                onPressed: () => _showDepartmentFormDialog(context, dept),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppConstants.dangerColor),
                                onPressed: () => ref.read(employeesControllerProvider.notifier).deleteDepartment(dept.id),
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
    );
  }

  // ==========================================
  // DESIGNATIONS TAB
  // ==========================================
  Widget _buildDesignationsTab(BuildContext context, dynamic state, bool isDark) {
    final desigs = state.designations;
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Available Designations', style: Theme.of(context).textTheme.titleLarge),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(170, 44),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Add Designation'),
                onPressed: () => _showDesignationFormDialog(context, null, state.departments),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: desigs.isEmpty
                ? const Center(child: Text('No designations added yet.'))
                : ListView.builder(
                    itemCount: desigs.length,
                    itemBuilder: (context, idx) {
                      final desig = desigs[idx];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              const CircleAvatar(child: Icon(Icons.badge)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(desig.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text('Dept Link ID: ${desig.departmentId}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: Colors.amber),
                                onPressed: () => _showDesignationFormDialog(context, desig, state.departments),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppConstants.dangerColor),
                                onPressed: () => ref.read(employeesControllerProvider.notifier).deleteDesignation(desig.id),
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
    );
  }

  // ==========================================
  // BRANCHES TAB
  // ==========================================
  Widget _buildBranchesTab(BuildContext context, dynamic state, bool isDark) {
    final branches = state.branches;
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Available Branches', style: Theme.of(context).textTheme.titleLarge),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(145, 44),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Add Branch'),
                onPressed: () => _showBranchFormDialog(context, null),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: branches.isEmpty
                ? const Center(child: Text('No branches added yet.'))
                : ListView.builder(
                    itemCount: branches.length,
                    itemBuilder: (context, idx) {
                      final branch = branches[idx];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              const CircleAvatar(child: Icon(Icons.location_on)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(branch.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(branch.address, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: Colors.amber),
                                onPressed: () => _showBranchFormDialog(context, branch),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppConstants.dangerColor),
                                onPressed: () => ref.read(employeesControllerProvider.notifier).deleteBranch(branch.id),
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
    );
  }

  // ==========================================
  // MODALS & DIALOGS
  // ==========================================

  void _showEmployeeDetailsDialog(BuildContext context, Employee emp) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${emp.firstName} ${emp.lastName} Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: emp.profilePhoto != null ? NetworkImage(emp.profilePhoto!) : null,
                  child: emp.profilePhoto == null ? Text('${emp.firstName[0]}${emp.lastName[0]}', style: const TextStyle(fontSize: 24)) : null,
                ),
                const SizedBox(height: 16),
                _detailRow('Employee Code', emp.employeeCode),
                _detailRow('Email', emp.email),
                _detailRow('Mobile Number', emp.mobileNumber),
                _detailRow('Role', emp.role.displayName),
                _detailRow('Department', emp.department),
                _detailRow('Designation', emp.designation),
                _detailRow('Branch', emp.branch),
                _detailRow('Joining Date', emp.joiningDate.toLocal().toString().substring(0, 10)),
                _detailRow('Date of Birth', emp.dateOfBirth.toLocal().toString().substring(0, 10)),
                _detailRow('Address', emp.address),
                _detailRow('Status', emp.status ? 'Active' : 'Inactive'),
                _detailRow('Created At', emp.createdDate.toLocal().toString().substring(0, 16)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            )
          ],
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteEmployee(BuildContext context, Employee emp) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete employee ${emp.firstName} ${emp.lastName} (${emp.employeeCode})?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppConstants.dangerColor),
              onPressed: () {
                ref.read(employeesControllerProvider.notifier).deleteEmployee(emp.employeeId);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showEmployeeFormDialog(BuildContext context, Employee? emp) {
    final formKey = GlobalKey<FormState>();
    final isEdit = emp != null;

    final firstController = TextEditingController(text: emp?.firstName ?? '');
    final lastController = TextEditingController(text: emp?.lastName ?? '');
    final emailController = TextEditingController(text: emp?.email ?? '');
    final mobileController = TextEditingController(text: emp?.mobileNumber ?? '');
    final addressController = TextEditingController(text: emp?.address ?? '');
    final photoController = TextEditingController(text: emp?.profilePhoto ?? '');

    String? deptVal = emp?.department;
    String? desigVal = emp?.designation;
    String? branchVal = emp?.branch;
    UserRole roleVal = emp?.role ?? UserRole.employee;
    String shiftVal = emp?.shift ?? 'India';
    DateTime dobVal = emp?.dateOfBirth ?? DateTime(1995, 1, 1);
    int? reportingToVal = emp?.reportingToId;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final state = ref.read(employeesControllerProvider);
            
            return AlertDialog(
              title: Text(isEdit ? 'Edit Employee' : 'Add Employee'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: firstController,
                        decoration: const InputDecoration(labelText: 'First Name'),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: lastController,
                        decoration: const InputDecoration(labelText: 'Last Name'),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: mobileController,
                        decoration: const InputDecoration(labelText: 'Mobile Number'),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<UserRole>(
                        initialValue: roleVal,
                        decoration: const InputDecoration(labelText: 'System Role'),
                        items: UserRole.values.map((role) {
                          return DropdownMenuItem<UserRole>(value: role, child: Text(role.displayName));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => roleVal = val);
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: state.departments.any((d) => d.name == deptVal) ? deptVal : null,
                        decoration: const InputDecoration(labelText: 'Department'),
                        items: state.departments.map((dept) {
                          return DropdownMenuItem<String>(value: dept.name, child: Text(dept.name));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => deptVal = val);
                        },
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: state.designations.any((d) => d.name == desigVal) ? desigVal : null,
                        decoration: const InputDecoration(labelText: 'Designation'),
                        items: state.designations.map((desig) {
                          return DropdownMenuItem<String>(value: desig.name, child: Text(desig.name));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => desigVal = val);
                        },
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: state.branches.any((b) => b.name == branchVal) ? branchVal : null,
                        decoration: const InputDecoration(labelText: 'Branch'),
                        items: state.branches.map((b) {
                          return DropdownMenuItem<String>(value: b.name, child: Text(b.name));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => branchVal = val);
                        },
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: shiftVal,
                        decoration: const InputDecoration(labelText: 'Shift Region'),
                        items: ['India', 'UK', 'US'].map((s) {
                          return DropdownMenuItem<String>(value: s, child: Text(s));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => shiftVal = val);
                        },
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        icon: const Icon(Icons.cake_outlined),
                        label: Text('Date of Birth: ${DateFormat('yyyy-MM-dd').format(dobVal)}'),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: dobVal,
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() => dobVal = date);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int?>(
                        initialValue: state.employees.any((e) => e.employeeId == reportingToVal) ? reportingToVal : null,
                        decoration: const InputDecoration(labelText: 'Reporting To (Supervisor)'),
                        items: [
                          const DropdownMenuItem<int?>(value: null, child: Text('None (Top Level)')),
                          ...state.employees.where((e) => e.employeeId != emp?.employeeId).map((e) {
                            return DropdownMenuItem<int?>(
                              value: e.employeeId,
                              child: Text('${e.firstName} ${e.lastName} (${e.employeeCode})'),
                            );
                          }),
                        ],
                        onChanged: (val) {
                          setState(() => reportingToVal = val);
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: addressController,
                        decoration: const InputDecoration(labelText: 'Address'),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: photoController,
                        decoration: const InputDecoration(
                          labelText: 'Profile Photo URL (Mock upload)',
                          hintText: 'https://...',
                        ),
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
                    
                    final Map<String, dynamic> data = {
                      "firstName": firstController.text,
                      "lastName": lastController.text,
                      "email": emailController.text,
                      "mobileNumber": mobileController.text,
                      "department": deptVal,
                      "designation": desigVal,
                      "branch": branchVal,
                      "shift": shiftVal,
                      "address": addressController.text,
                      "profilePhoto": photoController.text.isNotEmpty 
                          ? photoController.text 
                          : 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=200',
                      "status": emp?.status ?? true,
                      "role": roleVal.name,
                      "joiningDate": emp?.joiningDate.toIso8601String() ?? DateTime.now().toIso8601String(),
                      "dateOfBirth": dobVal.toIso8601String(),
                      "reportingToId": reportingToVal,
                      "password": 'Password123',
                    };

                    bool success;
                    if (isEdit) {
                      success = await ref.read(employeesControllerProvider.notifier).updateEmployee(emp.employeeId, data);
                    } else {
                      success = await ref.read(employeesControllerProvider.notifier).addEmployee(data);
                    }

                    if (success && context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Lookups Forms dialogs
  void _showDepartmentFormDialog(BuildContext context, dynamic dept) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: dept?.name ?? '');
    final codeController = TextEditingController(text: dept?.code ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(dept != null ? 'Edit Department' : 'Add Department'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Department Name'),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: codeController,
                  decoration: const InputDecoration(labelText: 'Department Code'),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
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
                bool success;
                if (dept != null) {
                  success = await ref.read(employeesControllerProvider.notifier).updateDepartment(dept.id, nameController.text, codeController.text);
                } else {
                  success = await ref.read(employeesControllerProvider.notifier).addDepartment(nameController.text, codeController.text);
                }
                if (success) {
                  if (context.mounted) Navigator.pop(context);
                } else {
                  if (context.mounted) {
                    final error = ref.read(employeesControllerProvider).errorMessage ?? 'An error occurred';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDesignationFormDialog(BuildContext context, dynamic desig, List<dynamic> depts) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: desig?.name ?? '');
    String? deptVal = depts.isNotEmpty ? depts[0].id.toString() : null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(desig != null ? 'Edit Designation' : 'Add Designation'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Designation Name'),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: deptVal,
                      decoration: const InputDecoration(labelText: 'Link Department'),
                      items: depts.map((d) {
                        return DropdownMenuItem<String>(value: d.id.toString(), child: Text(d.name));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => deptVal = val);
                      },
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
                    bool success;
                    if (desig != null) {
                      success = await ref.read(employeesControllerProvider.notifier).updateDesignation(desig.id, nameController.text, deptVal ?? '1');
                    } else {
                      success = await ref.read(employeesControllerProvider.notifier).addDesignation(nameController.text, deptVal ?? '1');
                    }
                    if (success) {
                      if (context.mounted) Navigator.pop(context);
                    } else {
                      if (context.mounted) {
                        final error = ref.read(employeesControllerProvider).errorMessage ?? 'An error occurred';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error), backgroundColor: Colors.red),
                        );
                      }
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showBranchFormDialog(BuildContext context, dynamic branch) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: branch?.name ?? '');
    final addrController = TextEditingController(text: branch?.address ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(branch != null ? 'Edit Branch' : 'Add Branch'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Branch Name'),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: addrController,
                  decoration: const InputDecoration(labelText: 'Branch Address'),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
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
                bool success;
                if (branch != null) {
                  success = await ref.read(employeesControllerProvider.notifier).updateBranch(branch.id, nameController.text, addrController.text);
                } else {
                  success = await ref.read(employeesControllerProvider.notifier).addBranch(nameController.text, addrController.text);
                }
                if (success) {
                  if (context.mounted) Navigator.pop(context);
                } else {
                  if (context.mounted) {
                    final error = ref.read(employeesControllerProvider).errorMessage ?? 'An error occurred';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
