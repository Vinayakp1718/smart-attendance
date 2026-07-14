// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'designation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DesignationImpl _$$DesignationImplFromJson(Map<String, dynamic> json) =>
    _$DesignationImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      departmentId: json['departmentId'] as String,
    );

Map<String, dynamic> _$$DesignationImplToJson(_$DesignationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'departmentId': instance.departmentId,
    };
