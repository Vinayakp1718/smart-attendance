import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/providers.dart';
import 'holidays_state.dart';

class HolidaysController extends StateNotifier<HolidaysState> {
  final Ref _ref;

  HolidaysController(this._ref) : super(const HolidaysState()) {
    loadHolidaysData();
  }

  Future<void> loadHolidaysData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(holidayRepositoryProvider);
      final list = await repo.getHolidays();
      final config = await repo.getWeekendConfig();

      // Sort holidays by date
      list.sort((a, b) => a.holidayDate.compareTo(b.holidayDate));

      state = HolidaysState(
        holidays: list,
        saturdayOff: config['saturdayOff'] ?? false,
        sundayOff: config['sundayOff'] ?? true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<bool> addHoliday(String name, String date, String description) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(holidayRepositoryProvider);
      await repo.addHoliday({
        "holidayName": name,
        "holidayDate": date,
        "description": description,
      });
      await loadHolidaysData();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> updateHoliday(int id, String name, String date, String description) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(holidayRepositoryProvider);
      await repo.updateHoliday(id, {
        "holidayName": name,
        "holidayDate": date,
        "description": description,
      });
      await loadHolidaysData();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> deleteHoliday(int id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(holidayRepositoryProvider);
      await repo.deleteHoliday(id);
      await loadHolidaysData();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> updateWeekendConfig({required bool saturdayOff, required bool sundayOff}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(holidayRepositoryProvider);
      await repo.updateWeekendConfig({
        "saturdayOff": saturdayOff,
        "sundayOff": sundayOff,
      });
      state = state.copyWith(
        saturdayOff: saturdayOff,
        sundayOff: sundayOff,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }
}

final holidaysControllerProvider = StateNotifierProvider<HolidaysController, HolidaysState>((ref) {
  return HolidaysController(ref);
});
