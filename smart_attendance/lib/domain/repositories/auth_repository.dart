import '../entities/employee.dart';

abstract class AuthRepository {
  Future<Employee> login(String email, String password, bool rememberMe);
  Future<Employee?> getCurrentUser();
  Future<void> logout();
  bool getRememberMe();
  String getSavedEmail();
}
