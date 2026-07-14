import 'package:freezed_annotation/freezed_annotation.dart';

part 'holiday.freezed.dart';
part 'holiday.g.dart';

@freezed
class Holiday with _$Holiday {
  const factory Holiday({
    required int holidayId,
    required String holidayName,
    required String holidayDate, // YYYY-MM-DD
    required String description,
  }) = _Holiday;

  factory Holiday.fromJson(Map<String, dynamic> json) => _$HolidayFromJson(json);
}
