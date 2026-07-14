// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'designation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Designation _$DesignationFromJson(Map<String, dynamic> json) {
  return _Designation.fromJson(json);
}

/// @nodoc
mixin _$Designation {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get departmentId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DesignationCopyWith<Designation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DesignationCopyWith<$Res> {
  factory $DesignationCopyWith(
          Designation value, $Res Function(Designation) then) =
      _$DesignationCopyWithImpl<$Res, Designation>;
  @useResult
  $Res call({int id, String name, String departmentId});
}

/// @nodoc
class _$DesignationCopyWithImpl<$Res, $Val extends Designation>
    implements $DesignationCopyWith<$Res> {
  _$DesignationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? departmentId = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      departmentId: null == departmentId
          ? _value.departmentId
          : departmentId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DesignationImplCopyWith<$Res>
    implements $DesignationCopyWith<$Res> {
  factory _$$DesignationImplCopyWith(
          _$DesignationImpl value, $Res Function(_$DesignationImpl) then) =
      __$$DesignationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String departmentId});
}

/// @nodoc
class __$$DesignationImplCopyWithImpl<$Res>
    extends _$DesignationCopyWithImpl<$Res, _$DesignationImpl>
    implements _$$DesignationImplCopyWith<$Res> {
  __$$DesignationImplCopyWithImpl(
      _$DesignationImpl _value, $Res Function(_$DesignationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? departmentId = null,
  }) {
    return _then(_$DesignationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      departmentId: null == departmentId
          ? _value.departmentId
          : departmentId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DesignationImpl implements _Designation {
  const _$DesignationImpl(
      {required this.id, required this.name, required this.departmentId});

  factory _$DesignationImpl.fromJson(Map<String, dynamic> json) =>
      _$$DesignationImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String departmentId;

  @override
  String toString() {
    return 'Designation(id: $id, name: $name, departmentId: $departmentId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DesignationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.departmentId, departmentId) ||
                other.departmentId == departmentId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, departmentId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DesignationImplCopyWith<_$DesignationImpl> get copyWith =>
      __$$DesignationImplCopyWithImpl<_$DesignationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DesignationImplToJson(
      this,
    );
  }
}

abstract class _Designation implements Designation {
  const factory _Designation(
      {required final int id,
      required final String name,
      required final String departmentId}) = _$DesignationImpl;

  factory _Designation.fromJson(Map<String, dynamic> json) =
      _$DesignationImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get departmentId;
  @override
  @JsonKey(ignore: true)
  _$$DesignationImplCopyWith<_$DesignationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
