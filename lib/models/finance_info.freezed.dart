// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'finance_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FinanceInfo _$FinanceInfoFromJson(Map<String, dynamic> json) {
  return _FinanceInfo.fromJson(json);
}

/// @nodoc
mixin _$FinanceInfo {
  String get id => throw _privateConstructorUsedError;
  String get tNumber => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get officialAddress => throw _privateConstructorUsedError;
  String get actualAddress => throw _privateConstructorUsedError;

  /// Serializes this FinanceInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FinanceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinanceInfoCopyWith<FinanceInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinanceInfoCopyWith<$Res> {
  factory $FinanceInfoCopyWith(
          FinanceInfo value, $Res Function(FinanceInfo) then) =
      _$FinanceInfoCopyWithImpl<$Res, FinanceInfo>;
  @useResult
  $Res call(
      {String id,
      String tNumber,
      String name,
      String officialAddress,
      String actualAddress});
}

/// @nodoc
class _$FinanceInfoCopyWithImpl<$Res, $Val extends FinanceInfo>
    implements $FinanceInfoCopyWith<$Res> {
  _$FinanceInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinanceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tNumber = null,
    Object? name = null,
    Object? officialAddress = null,
    Object? actualAddress = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tNumber: null == tNumber
          ? _value.tNumber
          : tNumber // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      officialAddress: null == officialAddress
          ? _value.officialAddress
          : officialAddress // ignore: cast_nullable_to_non_nullable
              as String,
      actualAddress: null == actualAddress
          ? _value.actualAddress
          : actualAddress // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FinanceInfoImplCopyWith<$Res>
    implements $FinanceInfoCopyWith<$Res> {
  factory _$$FinanceInfoImplCopyWith(
          _$FinanceInfoImpl value, $Res Function(_$FinanceInfoImpl) then) =
      __$$FinanceInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String tNumber,
      String name,
      String officialAddress,
      String actualAddress});
}

/// @nodoc
class __$$FinanceInfoImplCopyWithImpl<$Res>
    extends _$FinanceInfoCopyWithImpl<$Res, _$FinanceInfoImpl>
    implements _$$FinanceInfoImplCopyWith<$Res> {
  __$$FinanceInfoImplCopyWithImpl(
      _$FinanceInfoImpl _value, $Res Function(_$FinanceInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of FinanceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tNumber = null,
    Object? name = null,
    Object? officialAddress = null,
    Object? actualAddress = null,
  }) {
    return _then(_$FinanceInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tNumber: null == tNumber
          ? _value.tNumber
          : tNumber // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      officialAddress: null == officialAddress
          ? _value.officialAddress
          : officialAddress // ignore: cast_nullable_to_non_nullable
              as String,
      actualAddress: null == actualAddress
          ? _value.actualAddress
          : actualAddress // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FinanceInfoImpl implements _FinanceInfo {
  const _$FinanceInfoImpl(
      {required this.id,
      required this.tNumber,
      required this.name,
      required this.officialAddress,
      required this.actualAddress});

  factory _$FinanceInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinanceInfoImplFromJson(json);

  @override
  final String id;
  @override
  final String tNumber;
  @override
  final String name;
  @override
  final String officialAddress;
  @override
  final String actualAddress;

  @override
  String toString() {
    return 'FinanceInfo(id: $id, tNumber: $tNumber, name: $name, officialAddress: $officialAddress, actualAddress: $actualAddress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinanceInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tNumber, tNumber) || other.tNumber == tNumber) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.officialAddress, officialAddress) ||
                other.officialAddress == officialAddress) &&
            (identical(other.actualAddress, actualAddress) ||
                other.actualAddress == actualAddress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, tNumber, name, officialAddress, actualAddress);

  /// Create a copy of FinanceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinanceInfoImplCopyWith<_$FinanceInfoImpl> get copyWith =>
      __$$FinanceInfoImplCopyWithImpl<_$FinanceInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinanceInfoImplToJson(
      this,
    );
  }
}

abstract class _FinanceInfo implements FinanceInfo {
  const factory _FinanceInfo(
      {required final String id,
      required final String tNumber,
      required final String name,
      required final String officialAddress,
      required final String actualAddress}) = _$FinanceInfoImpl;

  factory _FinanceInfo.fromJson(Map<String, dynamic> json) =
      _$FinanceInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get tNumber;
  @override
  String get name;
  @override
  String get officialAddress;
  @override
  String get actualAddress;

  /// Create a copy of FinanceInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinanceInfoImplCopyWith<_$FinanceInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
