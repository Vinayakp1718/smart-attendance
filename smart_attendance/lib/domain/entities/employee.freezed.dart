// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Employee _$EmployeeFromJson(Map<String, dynamic> json) {
  return _Employee.fromJson(json);
}

/// @nodoc
mixin _$Employee {
  int get employeeId => throw _privateConstructorUsedError;
  String get employeeCode => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get mobileNumber => throw _privateConstructorUsedError;
  String get department => throw _privateConstructorUsedError;
  String get designation => throw _privateConstructorUsedError;
  String get branch => throw _privateConstructorUsedError;
  DateTime get joiningDate => throw _privateConstructorUsedError;
  DateTime get dateOfBirth => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String? get profilePhoto => throw _privateConstructorUsedError;
  bool get status => throw _privateConstructorUsedError;
  UserRole get role => throw _privateConstructorUsedError;
  String get shift => throw _privateConstructorUsedError;
  DateTime get createdDate => throw _privateConstructorUsedError;
  int? get reportingToId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EmployeeCopyWith<Employee> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeCopyWith<$Res> {
  factory $EmployeeCopyWith(Employee value, $Res Function(Employee) then) =
      _$EmployeeCopyWithImpl<$Res, Employee>;
  @useResult
  $Res call(
      {int employeeId,
      String employeeCode,
      String firstName,
      String lastName,
      String email,
      String mobileNumber,
      String department,
      String designation,
      String branch,
      DateTime joiningDate,
      DateTime dateOfBirth,
      String address,
      String? profilePhoto,
      bool status,
      UserRole role,
      String shift,
      DateTime createdDate,
      int? reportingToId});
}

/// @nodoc
class _$EmployeeCopyWithImpl<$Res, $Val extends Employee>
    implements $EmployeeCopyWith<$Res> {
  _$EmployeeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? employeeCode = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? mobileNumber = null,
    Object? department = null,
    Object? designation = null,
    Object? branch = null,
    Object? joiningDate = null,
    Object? dateOfBirth = null,
    Object? address = null,
    Object? profilePhoto = freezed,
    Object? status = null,
    Object? role = null,
    Object? shift = null,
    Object? createdDate = null,
    Object? reportingToId = freezed,
  }) {
    return _then(_value.copyWith(
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as int,
      employeeCode: null == employeeCode
          ? _value.employeeCode
          : employeeCode // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      mobileNumber: null == mobileNumber
          ? _value.mobileNumber
          : mobileNumber // ignore: cast_nullable_to_non_nullable
              as String,
      department: null == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String,
      designation: null == designation
          ? _value.designation
          : designation // ignore: cast_nullable_to_non_nullable
              as String,
      branch: null == branch
          ? _value.branch
          : branch // ignore: cast_nullable_to_non_nullable
              as String,
      joiningDate: null == joiningDate
          ? _value.joiningDate
          : joiningDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dateOfBirth: null == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      profilePhoto: freezed == profilePhoto
          ? _value.profilePhoto
          : profilePhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as bool,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      shift: null == shift
          ? _value.shift
          : shift // ignore: cast_nullable_to_non_nullable
              as String,
      createdDate: null == createdDate
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reportingToId: freezed == reportingToId
          ? _value.reportingToId
          : reportingToId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmployeeImplCopyWith<$Res>
    implements $EmployeeCopyWith<$Res> {
  factory _$$EmployeeImplCopyWith(
          _$EmployeeImpl value, $Res Function(_$EmployeeImpl) then) =
      __$$EmployeeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int employeeId,
      String employeeCode,
      String firstName,
      String lastName,
      String email,
      String mobileNumber,
      String department,
      String designation,
      String branch,
      DateTime joiningDate,
      DateTime dateOfBirth,
      String address,
      String? profilePhoto,
      bool status,
      UserRole role,
      String shift,
      DateTime createdDate,
      int? reportingToId});
}

/// @nodoc
class __$$EmployeeImplCopyWithImpl<$Res>
    extends _$EmployeeCopyWithImpl<$Res, _$EmployeeImpl>
    implements _$$EmployeeImplCopyWith<$Res> {
  __$$EmployeeImplCopyWithImpl(
      _$EmployeeImpl _value, $Res Function(_$EmployeeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? employeeCode = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? mobileNumber = null,
    Object? department = null,
    Object? designation = null,
    Object? branch = null,
    Object? joiningDate = null,
    Object? dateOfBirth = null,
    Object? address = null,
    Object? profilePhoto = freezed,
    Object? status = null,
    Object? role = null,
    Object? shift = null,
    Object? createdDate = null,
    Object? reportingToId = freezed,
  }) {
    return _then(_$EmployeeImpl(
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as int,
      employeeCode: null == employeeCode
          ? _value.employeeCode
          : employeeCode // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      mobileNumber: null == mobileNumber
          ? _value.mobileNumber
          : mobileNumber // ignore: cast_nullable_to_non_nullable
              as String,
      department: null == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String,
      designation: null == designation
          ? _value.designation
          : designation // ignore: cast_nullable_to_non_nullable
              as String,
      branch: null == branch
          ? _value.branch
          : branch // ignore: cast_nullable_to_non_nullable
              as String,
      joiningDate: null == joiningDate
          ? _value.joiningDate
          : joiningDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dateOfBirth: null == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      profilePhoto: freezed == profilePhoto
          ? _value.profilePhoto
          : profilePhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as bool,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      shift: null == shift
          ? _value.shift
          : shift // ignore: cast_nullable_to_non_nullable
              as String,
      createdDate: null == createdDate
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reportingToId: freezed == reportingToId
          ? _value.reportingToId
          : reportingToId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeImpl implements _Employee {
  const _$EmployeeImpl(
      {required this.employeeId,
      required this.employeeCode,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.mobileNumber,
      required this.department,
      required this.designation,
      required this.branch,
      required this.joiningDate,
      required this.dateOfBirth,
      required this.address,
      this.profilePhoto,
      required this.status,
      required this.role,
      this.shift = 'India',
      required this.createdDate,
      this.reportingToId});

  factory _$EmployeeImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeImplFromJson(json);

  @override
  final int employeeId;
  @override
  final String employeeCode;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String email;
  @override
  final String mobileNumber;
  @override
  final String department;
  @override
  final String designation;
  @override
  final String branch;
  @override
  final DateTime joiningDate;
  @override
  final DateTime dateOfBirth;
  @override
  final String address;
  @override
  final String? profilePhoto;
  @override
  final bool status;
  @override
  final UserRole role;
  @override
  @JsonKey()
  final String shift;
  @override
  final DateTime createdDate;
  @override
  final int? reportingToId;

  @override
  String toString() {
    return 'Employee(employeeId: $employeeId, employeeCode: $employeeCode, firstName: $firstName, lastName: $lastName, email: $email, mobileNumber: $mobileNumber, department: $department, designation: $designation, branch: $branch, joiningDate: $joiningDate, dateOfBirth: $dateOfBirth, address: $address, profilePhoto: $profilePhoto, status: $status, role: $role, shift: $shift, createdDate: $createdDate, reportingToId: $reportingToId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeImpl &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.employeeCode, employeeCode) ||
                other.employeeCode == employeeCode) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.mobileNumber, mobileNumber) ||
                other.mobileNumber == mobileNumber) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.designation, designation) ||
                other.designation == designation) &&
            (identical(other.branch, branch) || other.branch == branch) &&
            (identical(other.joiningDate, joiningDate) ||
                other.joiningDate == joiningDate) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.profilePhoto, profilePhoto) ||
                other.profilePhoto == profilePhoto) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.shift, shift) || other.shift == shift) &&
            (identical(other.createdDate, createdDate) ||
                other.createdDate == createdDate) &&
            (identical(other.reportingToId, reportingToId) ||
                other.reportingToId == reportingToId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      employeeId,
      employeeCode,
      firstName,
      lastName,
      email,
      mobileNumber,
      department,
      designation,
      branch,
      joiningDate,
      dateOfBirth,
      address,
      profilePhoto,
      status,
      role,
      shift,
      createdDate,
      reportingToId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeImplCopyWith<_$EmployeeImpl> get copyWith =>
      __$$EmployeeImplCopyWithImpl<_$EmployeeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeImplToJson(
      this,
    );
  }
}

abstract class _Employee implements Employee {
  const factory _Employee(
      {required final int employeeId,
      required final String employeeCode,
      required final String firstName,
      required final String lastName,
      required final String email,
      required final String mobileNumber,
      required final String department,
      required final String designation,
      required final String branch,
      required final DateTime joiningDate,
      required final DateTime dateOfBirth,
      required final String address,
      final String? profilePhoto,
      required final bool status,
      required final UserRole role,
      final String shift,
      required final DateTime createdDate,
      final int? reportingToId}) = _$EmployeeImpl;

  factory _Employee.fromJson(Map<String, dynamic> json) =
      _$EmployeeImpl.fromJson;

  @override
  int get employeeId;
  @override
  String get employeeCode;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get email;
  @override
  String get mobileNumber;
  @override
  String get department;
  @override
  String get designation;
  @override
  String get branch;
  @override
  DateTime get joiningDate;
  @override
  DateTime get dateOfBirth;
  @override
  String get address;
  @override
  String? get profilePhoto;
  @override
  bool get status;
  @override
  UserRole get role;
  @override
  String get shift;
  @override
  DateTime get createdDate;
  @override
  int? get reportingToId;
  @override
  @JsonKey(ignore: true)
  _$$EmployeeImplCopyWith<_$EmployeeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
