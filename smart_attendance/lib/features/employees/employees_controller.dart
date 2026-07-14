import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/providers.dart';
import 'employees_state.dart';

class EmployeesController extends StateNotifier<EmployeesState> {
  final Ref _ref;

  EmployeesController(this._ref) : super(const EmployeesState()) {
    loadAllData();
  }

  Future<void> loadAllData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(employeeRepositoryProvider);
      final employees = await repo.getEmployees();
      final depts = await repo.getDepartments();
      final desigs = await repo.getDesignations();
      final branches = await repo.getBranches();

      state = EmployeesState(
        employees: employees,
        departments: depts,
        designations: desigs,
        branches: branches,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  // --- Search and Filtering ---
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateDepartmentFilter(String? dept) {
    if (dept == null) {
      state = state.copyWith(clearDepartment: true);
    } else {
      state = state.copyWith(selectedDepartment: dept);
    }
  }

  void updateBranchFilter(String? branch) {
    if (branch == null) {
      state = state.copyWith(clearBranch: true);
    } else {
      state = state.copyWith(selectedBranch: branch);
    }
  }

  void updateStatusFilter(bool? status) {
    if (status == null) {
      state = state.copyWith(clearStatus: true);
    } else {
      state = state.copyWith(selectedStatus: status);
    }
  }

  void clearFilters() {
    state = state.copyWith(
      searchQuery: '',
      clearDepartment: true,
      clearBranch: true,
      clearStatus: true,
    );
  }

  // --- Employee CRUD Actions ---
  Future<bool> addEmployee(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(employeeRepositoryProvider);
      await repo.addEmployee(data);
      await loadAllData();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> updateEmployee(int id, Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(employeeRepositoryProvider);
      await repo.updateEmployee(id, data);
      await loadAllData();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> deleteEmployee(int id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(employeeRepositoryProvider);
      await repo.deleteEmployee(id);
      await loadAllData();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> toggleEmployeeStatus(int id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(employeeRepositoryProvider);
      await repo.toggleEmployeeStatus(id);
      await loadAllData();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  // --- Department CRUD Actions ---
  Future<bool> addDepartment(String name, String code) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(employeeRepositoryProvider);
      await repo.addDepartment(name, code);
      await loadAllData();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> updateDepartment(int id, String name, String code) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(employeeRepositoryProvider);
      await repo.updateDepartment(id, name, code);
      await loadAllData();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> deleteDepartment(int id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(employeeRepositoryProvider);
      await repo.deleteDepartment(id);
      await loadAllData();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  // --- Designation CRUD Actions ---
  Future<bool> addDesignation(String name, String departmentId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(employeeRepositoryProvider);
      await repo.addDesignation(name, departmentId);
      await loadAllData();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> updateDesignation(int id, String name, String departmentId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(employeeRepositoryProvider);
      await repo.updateDesignation(id, name, departmentId);
      await loadAllData();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> deleteDesignation(int id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(employeeRepositoryProvider);
      await repo.deleteDesignation(id);
      await loadAllData();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  // --- Branch CRUD Actions ---
  Future<bool> addBranch(String name, String address) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(employeeRepositoryProvider);
      await repo.addBranch(name, address);
      await loadAllData();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> updateBranch(int id, String name, String address) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(employeeRepositoryProvider);
      await repo.updateBranch(id, name, address);
      await loadAllData();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> deleteBranch(int id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(employeeRepositoryProvider);
      await repo.deleteBranch(id);
      await loadAllData();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }
}

final employeesControllerProvider = StateNotifierProvider<EmployeesController, EmployeesState>((ref) {
  return EmployeesController(ref);
});
