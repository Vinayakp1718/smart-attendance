import '../../domain/entities/holiday.dart';

class HolidaysState {
  final List<Holiday> holidays;
  final bool saturdayOff;
  final bool sundayOff;
  final bool isLoading;
  final String? errorMessage;

  const HolidaysState({
    this.holidays = const [],
    this.saturdayOff = false,
    this.sundayOff = true,
    this.isLoading = false,
    this.errorMessage,
  });

  HolidaysState copyWith({
    List<Holiday>? holidays,
    bool? saturdayOff,
    bool? sundayOff,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HolidaysState(
      holidays: holidays ?? this.holidays,
      saturdayOff: saturdayOff ?? this.saturdayOff,
      sundayOff: sundayOff ?? this.sundayOff,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
