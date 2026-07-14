import 'package:dio/dio.dart';
import '../../domain/entities/employee.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/services/storage_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final StorageService _storage;
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:5170/api'));

  AuthRepositoryImpl(this._storage);

  @override
  Future<Employee> login(String email, String password, bool rememberMe) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final userMap = response.data as Map<String, dynamic>;
      
      // Save session in Hive
      await _storage.saveUserSession(userMap);
      await _storage.setRememberMe(rememberMe);
      if (rememberMe) {
        await _storage.saveRememberedEmail(email);
      } else {
        await _storage.clearRememberedEmail();
      }

      return Employee.fromJson(userMap);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? e.message ?? "Connection error";
      throw Exception(message);
    }
  }

  @override
  Future<Employee?> getCurrentUser() async {
    final session = _storage.getUserSession();
    if (session == null) return null;
    return Employee.fromJson(session);
  }

  @override
  Future<void> logout() async {
    await _storage.clearUserSession();
  }

  @override
  bool getRememberMe() {
    return _storage.getRememberMe();
  }

  @override
  String getSavedEmail() {
    return _storage.getRememberedEmail();
  }
}
