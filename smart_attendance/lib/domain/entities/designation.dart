import 'package:freezed_annotation/freezed_annotation.dart';

part 'designation.freezed.dart';
part 'designation.g.dart';

@freezed
class Designation with _$Designation {
  const factory Designation({
    required int id,
    required String name,
    required String departmentId, // links to department if needed, or simple string
  }) = _Designation;

  factory Designation.fromJson(Map<String, dynamic> json) => _$DesignationFromJson(json);
}
