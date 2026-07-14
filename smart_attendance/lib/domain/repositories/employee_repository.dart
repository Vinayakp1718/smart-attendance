import '../entities/employee.dart';
import '../entities/department.dart';
import '../entities/designation.dart';
import '../entities/branch.dart';

abstract class EmployeeRepository {
  Future<List<Employee>> getEmployees();
  Future<Employee> addEmployee(Map<String, dynamic> employeeData);
  Future<Employee> updateEmployee(int id, Map<String, dynamic> employeeData);
  Future<void> deleteEmployee(int id);
  Future<Employee> toggleEmployeeStatus(int id);

  // Department
  Future<List<Department>> getDepartments();
  Future<Department> addDepartment(String name, String code);
  Future<Department> updateDepartment(int id, String name, String code);
  Future<void> deleteDepartment(int id);

  // Designation
  Future<List<Designation>> getDesignations();
  Future<Designation> addDesignation(String name, String departmentId);
  Future<Designation> updateDesignation(int id, String name, String departmentId);
  Future<void> deleteDesignation(int id);

  // Branch
  Future<List<Branch>> getBranches();
  Future<Branch> addBranch(String name, String address);
  Future<Branch> updateBranch(int id, String name, String address);
  Future<void> deleteBranch(int id);
}
