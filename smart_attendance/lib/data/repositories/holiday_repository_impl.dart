import 'package:dio/dio.dart';
import '../../domain/entities/holiday.dart';
import '../../domain/repositories/holiday_repository.dart';

class HolidayRepositoryImpl implements HolidayRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:5170/api'));

  @override
  Future<List<Holiday>> getHolidays() async {
    final response = await _dio.get('/holiday');
    final list = response.data as List;
    return list.map((e) => Holiday.fromJson(e)).toList();
  }

  @override
  Future<Holiday> addHoliday(Map<String, dynamic> holidayData) async {
    final response = await _dio.post('/holiday', data: holidayData);
    return Holiday.fromJson(response.data);
  }

  @override
  Future<Holiday> updateHoliday(int id, Map<String, dynamic> holidayData) async {
    // Just mock update locally or hit API
    return Holiday.fromJson({
      'holidayId': id,
      ...holidayData,
    });
  }

  @override
  Future<void> deleteHoliday(int id) async {
    await _dio.delete('/holiday/$id');
  }

  @override
  Future<Map<String, bool>> getWeekendConfig() async {
    return {
      'Monday': false,
      'Tuesday': false,
      'Wednesday': false,
      'Thursday': false,
      'Friday': false,
      'Saturday': true,
      'Sunday': true,
    };
  }

  @override
  Future<void> updateWeekendConfig(Map<String, bool> config) async {
    // No-op local setting
  }
}
