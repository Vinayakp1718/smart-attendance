import 'dart:math';
import '../../core/services/storage_service.dart';

class HolidayApiService {
  final StorageService _storage;

  HolidayApiService(this._storage);

  Future<List<Map<String, dynamic>>> getHolidays() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _storage.getHolidays();
  }

  Future<Map<String, dynamic>> addHoliday(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final List<Map<String, dynamic>> holidays = _storage.getHolidays();
    final int newId = holidays.isEmpty 
        ? 1 
        : holidays.map((e) => e['holidayId'] as int).reduce(max) + 1;

    final Map<String, dynamic> newItem = {
      ...data,
      "holidayId": newId,
    };

    holidays.add(newItem);
    await _storage.saveHolidays(holidays);
    return newItem;
  }

  Future<Map<String, dynamic>> updateHoliday(int id, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final List<Map<String, dynamic>> holidays = _storage.getHolidays();
    final index = holidays.indexWhere((h) => h['holidayId'] == id);
    if (index == -1) throw Exception("Holiday not found");

    final Map<String, dynamic> updated = {
      ...holidays[index],
      ...data,
    };
    holidays[index] = updated;
    await _storage.saveHolidays(holidays);
    return updated;
  }

  Future<void> deleteHoliday(int id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final List<Map<String, dynamic>> holidays = _storage.getHolidays();
    holidays.removeWhere((h) => h['holidayId'] == id);
    await _storage.saveHolidays(holidays);
  }

  Future<Map<String, dynamic>> getWeekendConfig() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _storage.getWeekendConfig();
  }

  Future<void> updateWeekendConfig(Map<String, dynamic> config) async {
    await Future.delayed(const Duration(milliseconds: 300));
    await _storage.saveWeekendConfig(config);
  }
}
