import 'package:dio/dio.dart';
import '../../domain/entities/employee.dart';
import '../../domain/entities/department.dart';
import '../../domain/entities/designation.dart';
import '../../domain/entities/branch.dart';
import '../../domain/repositories/employee_repository.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:5170/api'));

  @override
  Future<List<Employee>> getEmployees() async {
    final response = await _dio.get('/employee');
    final list = response.data as List;
    return list.map((e) => Employee.fromJson(e)).toList();
  }

  @override
  Future<Employee> addEmployee(Map<String, dynamic> employeeData) async {
    final response = await _dio.post('/employee', data: employeeData);
    return Employee.fromJson(response.data);
  }

  @override
  Future<Employee> updateEmployee(int id, Map<String, dynamic> employeeData) async {
    final response = await _dio.put('/employee/$id', data: employeeData);
    return Employee.fromJson(response.data);
  }

  @override
  Future<void> deleteEmployee(int id) async {
    await _dio.delete('/employee/$id');
  }

  @override
  Future<Employee> toggleEmployeeStatus(int id) async {
    final response = await _dio.post('/employee/$id/toggle-status');
    return Employee.fromJson(response.data);
  }

  // --- Department CRUD ---
  @override
  Future<List<Department>> getDepartments() async {
    final response = await _dio.get('/lookup/departments');
    final list = response.data as List;
    return list.map((e) => Department.fromJson(e)).toList();
  }

  @override
  Future<Department> addDepartment(String name, String code) async {
    final response = await _dio.post('/lookup/departments', data: {
      'name': name,
      'code': code,
    });
    return Department.fromJson(response.data);
  }

  @override
  Future<Department> updateDepartment(int id, String name, String code) async {
    final response = await _dio.put('/lookup/departments/$id', data: {
      'name': name,
      'code': code,
    });
    return Department.fromJson(response.data);
  }

  @override
  Future<void> deleteDepartment(int id) async {
    await _dio.delete('/lookup/departments/$id');
  }

  // --- Designation CRUD ---
  @override
  Future<List<Designation>> getDesignations() async {
    final response = await _dio.get('/lookup/designations');
    final list = response.data as List;
    return list.map((e) => Designation.fromJson(e)).toList();
  }

  @override
  Future<Designation> addDesignation(String name, String departmentId) async {
    final response = await _dio.post('/lookup/designations', data: {
      'name': name,
      'departmentId': departmentId,
    });
    return Designation.fromJson(response.data);
  }

  @override
  Future<Designation> updateDesignation(int id, String name, String departmentId) async {
    final response = await _dio.put('/lookup/designations/$id', data: {
      'name': name,
      'departmentId': departmentId,
    });
    return Designation.fromJson(response.data);
  }

  @override
  Future<void> deleteDesignation(int id) async {
    await _dio.delete('/lookup/designations/$id');
  }

  // --- Branch CRUD ---
  @override
  Future<List<Branch>> getBranches() async {
    final response = await _dio.get('/lookup/branches');
    final list = response.data as List;
    return list.map((e) => Branch.fromJson(e)).toList();
  }

  @override
  Future<Branch> addBranch(String name, String address) async {
    final response = await _dio.post('/lookup/branches', data: {
      'name': name,
      'address': address,
    });
    return Branch.fromJson(response.data);
  }

  @override
  Future<Branch> updateBranch(int id, String name, String address) async {
    final response = await _dio.put('/lookup/branches/$id', data: {
      'name': name,
      'address': address,
    });
    return Branch.fromJson(response.data);
  }

  @override
  Future<void> deleteBranch(int id) async {
    await _dio.delete('/lookup/branches/$id');
  }
}
