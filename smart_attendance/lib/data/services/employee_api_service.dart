import 'dart:math';
import '../../core/services/storage_service.dart';

class EmployeeApiService {
  final StorageService _storage;

  EmployeeApiService(this._storage);

  Future<List<Map<String, dynamic>>> getEmployees() async {
    await Future.delayed(const Duration(milliseconds: 600)); // Network latency simulator
    return _storage.getEmployees();
  }

  Future<Map<String, dynamic>> addEmployee(Map<String, dynamic> employeeData) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final List<Map<String, dynamic>> employees = _storage.getEmployees();

    // Auto-generate ID
    final int newId = employees.isEmpty 
        ? 1 
        : employees.map((e) => e['employeeId'] as int).reduce(max) + 1;

    // Auto-generate Employee Code (e.g., EMP0006)
    final String employeeCode = 'EMP${newId.toString().padLeft(4, '0')}';

    final Map<String, dynamic> newEmployee = {
      ...employeeData,
      'employeeId': newId,
      'employeeCode': employeeCode,
      'createdDate': DateTime.now().toIso8601String(),
    };

    employees.add(newEmployee);
    await _storage.saveEmployees(employees);

    // Seed empty leave balance for this new employee
    final List<Map<String, dynamic>> balances = _storage.getLeaveBalances();
    balances.add({
      "employeeId": newId,
      "sickLeave": 12,
      "casualLeave": 12,
      "paidLeave": 18
    });
    await _storage.saveLeaveBalances(balances);

    return newEmployee;
  }

  Future<Map<String, dynamic>> updateEmployee(int id, Map<String, dynamic> employeeData) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final List<Map<String, dynamic>> employees = _storage.getEmployees();
    final index = employees.indexWhere((e) => e['employeeId'] == id);
    if (index == -1) throw Exception("Employee not found");

    final Map<String, dynamic> updated = {
      ...employees[index],
      ...employeeData,
    };
    employees[index] = updated;
    await _storage.saveEmployees(employees);
    return updated;
  }

  Future<void> deleteEmployee(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final List<Map<String, dynamic>> employees = _storage.getEmployees();
    employees.removeWhere((e) => e['employeeId'] == id);
    await _storage.saveEmployees(employees);
  }

  Future<Map<String, dynamic>> toggleStatus(int id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final List<Map<String, dynamic>> employees = _storage.getEmployees();
    final index = employees.indexWhere((e) => e['employeeId'] == id);
    if (index == -1) throw Exception("Employee not found");

    final bool currentStatus = employees[index]['status'] as bool;
    employees[index]['status'] = !currentStatus;
    await _storage.saveEmployees(employees);
    return employees[index];
  }

  // --- Department CRUD ---
  Future<List<Map<String, dynamic>>> getDepartments() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _storage.getDepartments();
  }

  Future<Map<String, dynamic>> addDepartment(String name, String code) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final List<Map<String, dynamic>> items = _storage.getDepartments();
    final int newId = items.isEmpty ? 1 : items.map((e) => e['id'] as int).reduce(max) + 1;
    final Map<String, dynamic> newItem = {"id": newId, "name": name, "code": code};
    items.add(newItem);
    await _storage.saveDepartments(items);
    return newItem;
  }

  Future<Map<String, dynamic>> updateDepartment(int id, String name, String code) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final List<Map<String, dynamic>> items = _storage.getDepartments();
    final index = items.indexWhere((e) => e['id'] == id);
    if (index == -1) throw Exception("Department not found");
    items[index] = {"id": id, "name": name, "code": code};
    await _storage.saveDepartments(items);
    return items[index];
  }

  Future<void> deleteDepartment(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final List<Map<String, dynamic>> items = _storage.getDepartments();
    items.removeWhere((e) => e['id'] == id);
    await _storage.saveDepartments(items);
  }

  // --- Designation CRUD ---
  Future<List<Map<String, dynamic>>> getDesignations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _storage.getDesignations();
  }

  Future<Map<String, dynamic>> addDesignation(String name, String departmentId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final List<Map<String, dynamic>> items = _storage.getDesignations();
    final int newId = items.isEmpty ? 1 : items.map((e) => e['id'] as int).reduce(max) + 1;
    final Map<String, dynamic> newItem = {"id": newId, "name": name, "departmentId": departmentId};
    items.add(newItem);
    await _storage.saveDesignations(items);
    return newItem;
  }

  Future<Map<String, dynamic>> updateDesignation(int id, String name, String departmentId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final List<Map<String, dynamic>> items = _storage.getDesignations();
    final index = items.indexWhere((e) => e['id'] == id);
    if (index == -1) throw Exception("Designation not found");
    items[index] = {"id": id, "name": name, "departmentId": departmentId};
    await _storage.saveDesignations(items);
    return items[index];
  }

  Future<void> deleteDesignation(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final List<Map<String, dynamic>> items = _storage.getDesignations();
    items.removeWhere((e) => e['id'] == id);
    await _storage.saveDesignations(items);
  }

  // --- Branch CRUD ---
  Future<List<Map<String, dynamic>>> getBranches() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _storage.getBranches();
  }

  Future<Map<String, dynamic>> addBranch(String name, String address) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final List<Map<String, dynamic>> items = _storage.getBranches();
    final int newId = items.isEmpty ? 1 : items.map((e) => e['id'] as int).reduce(max) + 1;
    final Map<String, dynamic> newItem = {"id": newId, "name": name, "address": address};
    items.add(newItem);
    await _storage.saveBranches(items);
    return newItem;
  }

  Future<Map<String, dynamic>> updateBranch(int id, String name, String address) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final List<Map<String, dynamic>> items = _storage.getBranches();
    final index = items.indexWhere((e) => e['id'] == id);
    if (index == -1) throw Exception("Branch not found");
    items[index] = {"id": id, "name": name, "address": address};
    await _storage.saveBranches(items);
    return items[index];
  }

  Future<void> deleteBranch(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final List<Map<String, dynamic>> items = _storage.getBranches();
    items.removeWhere((e) => e['id'] == id);
    await _storage.saveBranches(items);
  }
}
