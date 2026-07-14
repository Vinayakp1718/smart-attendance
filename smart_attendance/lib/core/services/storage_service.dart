import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const String _sessionBoxName = 'session_box';
  static const String _dbBoxName = 'db_box';

  static const String _keyCurrentUser = 'current_user';
  static const String _keyRememberMe = 'remember_me';
  static const String _keySavedEmail = 'saved_email';

  static const String _keyEmployees = 'employees_table';
  static const String _keyAttendance = 'attendance_table';
  static const String _keyLeaves = 'leaves_table';
  static const String _keyHolidays = 'holidays_table';
  
  static const String _keyDepartments = 'departments_table';
  static const String _keyDesignations = 'designations_table';
  static const String _keyBranches = 'branches_table';
  static const String _keyLeaveBalances = 'leave_balances_table';
  static const String _keyWeekendConfig = 'weekend_config';

  late Box _sessionBox;
  late Box _dbBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _sessionBox = await Hive.openBox(_sessionBoxName);
    _dbBox = await Hive.openBox(_dbBoxName);
    await _seedDatabaseIfNeeded();
  }

  // --- Mock Database Seeding ---
  Future<void> _seedDatabaseIfNeeded() async {
    // Check if database is already seeded
    if (_dbBox.containsKey(_keyEmployees)) return;

    try {
      // Load static JSON files from assets and seed Hive
      final String employeesJson = await rootBundle.loadString('assets/mock_data/employees.json');
      await _dbBox.put(_keyEmployees, employeesJson);

      final String attendanceJson = await rootBundle.loadString('assets/mock_data/attendance.json');
      await _dbBox.put(_keyAttendance, attendanceJson);

      final String leavesJson = await rootBundle.loadString('assets/mock_data/leave_requests.json');
      await _dbBox.put(_keyLeaves, leavesJson);

      final String holidaysJson = await rootBundle.loadString('assets/mock_data/holidays.json');
      await _dbBox.put(_keyHolidays, holidaysJson);

      // Seed default Master Lookups
      final List<Map<String, dynamic>> defaultDepts = [
        {"id": 1, "name": "Executive", "code": "EXE"},
        {"id": 2, "name": "Human Resources", "code": "HR"},
        {"id": 3, "name": "Engineering", "code": "ENG"},
        {"id": 4, "name": "Finance", "code": "FIN"},
        {"id": 5, "name": "Sales", "code": "SLS"}
      ];
      await _dbBox.put(_keyDepartments, jsonEncode(defaultDepts));

      final List<Map<String, dynamic>> defaultDesigs = [
        {"id": 1, "name": "Chief Executive Officer", "departmentId": "1"},
        {"id": 2, "name": "HR Manager", "departmentId": "2"},
        {"id": 3, "name": "HR Associate", "departmentId": "2"},
        {"id": 4, "name": "Senior Flutter Developer", "departmentId": "3"},
        {"id": 5, "name": "QA Engineer", "departmentId": "3"},
        {"id": 6, "name": "Senior Accountant", "departmentId": "4"},
        {"id": 7, "name": "Sales Executive", "departmentId": "5"}
      ];
      await _dbBox.put(_keyDesignations, jsonEncode(defaultDesigs));

      final List<Map<String, dynamic>> defaultBranches = [
        {"id": 1, "name": "Headquarters (Pune)", "address": "120 Hinjewadi, Pune"},
        {"id": 2, "name": "Mumbai Branch", "address": "40 Lower Parel, Mumbai"},
        {"id": 3, "name": "Bangalore Branch", "address": "100 Indiranagar, Bangalore"}
      ];
      await _dbBox.put(_keyBranches, jsonEncode(defaultBranches));

      // Seed Leave Balances for initial employees
      final List<Map<String, dynamic>> defaultBalances = [
        {"employeeId": 1, "sickLeave": 12, "casualLeave": 12, "paidLeave": 18},
        {"employeeId": 2, "sickLeave": 12, "casualLeave": 12, "paidLeave": 18},
        {"employeeId": 3, "sickLeave": 10, "casualLeave": 12, "paidLeave": 18}, // Used 2 sick leaves in mock data
        {"employeeId": 4, "sickLeave": 12, "casualLeave": 12, "paidLeave": 18},
        {"employeeId": 5, "sickLeave": 12, "casualLeave": 12, "paidLeave": 18}
      ];
      await _dbBox.put(_keyLeaveBalances, jsonEncode(defaultBalances));

      // Weekend Config: Saturday optional (false by default/off), Sunday weekly off (true)
      final Map<String, dynamic> weekendConfig = {
        "saturdayOff": false,
        "sundayOff": true
      };
      await _dbBox.put(_keyWeekendConfig, jsonEncode(weekendConfig));
      
    } catch (e) {
      // Fallback in case of asset loading issues during testing
      await _dbBox.put(_keyEmployees, '[]');
      await _dbBox.put(_keyAttendance, '[]');
      await _dbBox.put(_keyLeaves, '[]');
      await _dbBox.put(_keyHolidays, '[]');
      await _dbBox.put(_keyDepartments, '[]');
      await _dbBox.put(_keyDesignations, '[]');
      await _dbBox.put(_keyBranches, '[]');
      await _dbBox.put(_keyLeaveBalances, '[]');
      await _dbBox.put(_keyWeekendConfig, '{"saturdayOff":false,"sundayOff":true}');
    }
  }

  // --- Session Storage Methods ---
  Future<void> saveUserSession(Map<String, dynamic> userJson) async {
    await _sessionBox.put(_keyCurrentUser, jsonEncode(userJson));
  }

  Map<String, dynamic>? getUserSession() {
    final String? userStr = _sessionBox.get(_keyCurrentUser);
    if (userStr == null) return null;
    return jsonDecode(userStr) as Map<String, dynamic>;
  }

  Future<void> clearUserSession() async {
    await _sessionBox.delete(_keyCurrentUser);
  }

  Future<void> setRememberMe(bool value) async {
    await _sessionBox.put(_keyRememberMe, value);
  }

  bool getRememberMe() {
    return _sessionBox.get(_keyRememberMe, defaultValue: false) as bool;
  }

  Future<void> saveRememberedEmail(String email) async {
    await _sessionBox.put(_keySavedEmail, email);
  }

  String getRememberedEmail() {
    return _sessionBox.get(_keySavedEmail, defaultValue: '') as String;
  }

  Future<void> clearRememberedEmail() async {
    await _sessionBox.delete(_keySavedEmail);
  }

  // --- Database CRUD Helper Methods ---
  List<Map<String, dynamic>> _getTable(String key) {
    final String? jsonStr = _dbBox.get(key);
    if (jsonStr == null) return [];
    final List<dynamic> decoded = jsonDecode(jsonStr);
    return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> _saveTable(String key, List<Map<String, dynamic>> data) async {
    await _dbBox.put(key, jsonEncode(data));
  }

  // Employees Collection
  List<Map<String, dynamic>> getEmployees() => _getTable(_keyEmployees);
  Future<void> saveEmployees(List<Map<String, dynamic>> data) => _saveTable(_keyEmployees, data);

  // Attendance Collection
  List<Map<String, dynamic>> getAttendance() => _getTable(_keyAttendance);
  Future<void> saveAttendance(List<Map<String, dynamic>> data) => _saveTable(_keyAttendance, data);

  // Leaves Collection
  List<Map<String, dynamic>> getLeaves() => _getTable(_keyLeaves);
  Future<void> saveLeaves(List<Map<String, dynamic>> data) => _saveTable(_keyLeaves, data);

  // Holidays Collection
  List<Map<String, dynamic>> getHolidays() => _getTable(_keyHolidays);
  Future<void> saveHolidays(List<Map<String, dynamic>> data) => _saveTable(_keyHolidays, data);

  // Department Collection
  List<Map<String, dynamic>> getDepartments() => _getTable(_keyDepartments);
  Future<void> saveDepartments(List<Map<String, dynamic>> data) => _saveTable(_keyDepartments, data);

  // Designation Collection
  List<Map<String, dynamic>> getDesignations() => _getTable(_keyDesignations);
  Future<void> saveDesignations(List<Map<String, dynamic>> data) => _saveTable(_keyDesignations, data);

  // Branch Collection
  List<Map<String, dynamic>> getBranches() => _getTable(_keyBranches);
  Future<void> saveBranches(List<Map<String, dynamic>> data) => _saveTable(_keyBranches, data);

  // Leave Balances Collection
  List<Map<String, dynamic>> getLeaveBalances() => _getTable(_keyLeaveBalances);
  Future<void> saveLeaveBalances(List<Map<String, dynamic>> data) => _saveTable(_keyLeaveBalances, data);

  // Weekend Configuration
  Map<String, dynamic> getWeekendConfig() {
    final String? jsonStr = _dbBox.get(_keyWeekendConfig);
    if (jsonStr == null) return {"saturdayOff": false, "sundayOff": true};
    return Map<String, dynamic>.from(jsonDecode(jsonStr));
  }
  Future<void> saveWeekendConfig(Map<String, dynamic> config) async {
    await _dbBox.put(_keyWeekendConfig, jsonEncode(config));
  }
}
