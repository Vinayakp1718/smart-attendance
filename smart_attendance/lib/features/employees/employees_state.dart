import '../../domain/entities/employee.dart';
import '../../domain/entities/department.dart';
import '../../domain/entities/designation.dart';
import '../../domain/entities/branch.dart';

class EmployeesState {
  final List<Employee> employees;
  final List<Department> departments;
  final List<Designation> designations;
  final List<Branch> branches;
  final bool isLoading;
  final String? errorMessage;
  
  // Active filters
  final String searchQuery;
  final String? selectedDepartment;
  final String? selectedBranch;
  final bool? selectedStatus;

  const EmployeesState({
    this.employees = const [],
    this.departments = const [],
    this.designations = const [],
    this.branches = const [],
    this.isLoading = false,
    this.errorMessage,
    this.searchQuery = '',
    this.selectedDepartment,
    this.selectedBranch,
    this.selectedStatus,
  });

  List<Employee> get filteredEmployees {
    return employees.where((emp) {
      // 1. Search Query Filter (name, email, code)
      final query = searchQuery.trim().toLowerCase();
      if (query.isNotEmpty) {
        final name = '${emp.firstName} ${emp.lastName}'.toLowerCase();
        final email = emp.email.toLowerCase();
        final code = emp.employeeCode.toLowerCase();
        if (!name.contains(query) && !email.contains(query) && !code.contains(query)) {
          return false;
        }
      }

      // 2. Department Filter
      if (selectedDepartment != null && selectedDepartment!.isNotEmpty) {
        if (emp.department != selectedDepartment) return false;
      }

      // 3. Branch Filter
      if (selectedBranch != null && selectedBranch!.isNotEmpty) {
        if (emp.branch != selectedBranch) return false;
      }

      // 4. Status Filter
      if (selectedStatus != null) {
        if (emp.status != selectedStatus) return false;
      }

      return true;
    }).toList();
  }

  EmployeesState copyWith({
    List<Employee>? employees,
    List<Department>? departments,
    List<Designation>? designations,
    List<Branch>? branches,
    bool? isLoading,
    String? errorMessage,
    String? searchQuery,
    String? selectedDepartment,
    String? selectedBranch,
    bool? selectedStatus,
    // Helpers to clear optional selections
    bool clearDepartment = false,
    bool clearBranch = false,
    bool clearStatus = false,
  }) {
    return EmployeesState(
      employees: employees ?? this.employees,
      departments: departments ?? this.departments,
      designations: designations ?? this.designations,
      branches: branches ?? this.branches,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedDepartment: clearDepartment ? null : (selectedDepartment ?? this.selectedDepartment),
      selectedBranch: clearBranch ? null : (selectedBranch ?? this.selectedBranch),
      selectedStatus: clearStatus ? null : (selectedStatus ?? this.selectedStatus),
    );
  }
}
