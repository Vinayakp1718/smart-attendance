import '../entities/holiday.dart';

abstract class HolidayRepository {
  Future<List<Holiday>> getHolidays();
  Future<Holiday> addHoliday(Map<String, dynamic> holidayData);
  Future<Holiday> updateHoliday(int id, Map<String, dynamic> holidayData);
  Future<void> deleteHoliday(int id);
  Future<Map<String, bool>> getWeekendConfig();
  Future<void> updateWeekendConfig(Map<String, bool> config);
}
