// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holiday.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HolidayImpl _$$HolidayImplFromJson(Map<String, dynamic> json) =>
    _$HolidayImpl(
      holidayId: (json['holidayId'] as num).toInt(),
      holidayName: json['holidayName'] as String,
      holidayDate: json['holidayDate'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$$HolidayImplToJson(_$HolidayImpl instance) =>
    <String, dynamic>{
      'holidayId': instance.holidayId,
      'holidayName': instance.holidayName,
      'holidayDate': instance.holidayDate,
      'description': instance.description,
    };
