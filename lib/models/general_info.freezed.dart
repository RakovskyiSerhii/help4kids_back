// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'general_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GeneralInfo _$GeneralInfoFromJson(Map<String, dynamic> json) {
  return _GeneralInfo.fromJson(json);
}

/// @nodoc
mixin _$GeneralInfo {
  List<Unit> get units => throw _privateConstructorUsedError;
  List<SocialContact> get socialContacts => throw _privateConstructorUsedError;
  List<FinanceInfo> get financeInfos => throw _privateConstructorUsedError;
  List<Consultation> get consultations => throw _privateConstructorUsedError;

  /// Serializes this GeneralInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GeneralInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeneralInfoCopyWith<GeneralInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeneralInfoCopyWith<$Res> {
  factory $GeneralInfoCopyWith(
          GeneralInfo value, $Res Function(GeneralInfo) then) =
      _$GeneralInfoCopyWithImpl<$Res, GeneralInfo>;
  @useResult
  $Res call(
      {List<Unit> units,
      List<SocialContact> socialContacts,
      List<FinanceInfo> financeInfos,
      List<Consultation> consultations});
}

/// @nodoc
class _$GeneralInfoCopyWithImpl<$Res, $Val extends GeneralInfo>
    implements $GeneralInfoCopyWith<$Res> {
  _$GeneralInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeneralInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? units = null,
    Object? socialContacts = null,
    Object? financeInfos = null,
    Object? consultations = null,
  }) {
    return _then(_value.copyWith(
      units: null == units
          ? _value.units
          : units // ignore: cast_nullable_to_non_nullable
              as List<Unit>,
      socialContacts: null == socialContacts
          ? _value.socialContacts
          : socialContacts // ignore: cast_nullable_to_non_nullable
              as List<SocialContact>,
      financeInfos: null == financeInfos
          ? _value.financeInfos
          : financeInfos // ignore: cast_nullable_to_non_nullable
              as List<FinanceInfo>,
      consultations: null == consultations
          ? _value.consultations
          : consultations // ignore: cast_nullable_to_non_nullable
              as List<Consultation>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GeneralInfoImplCopyWith<$Res>
    implements $GeneralInfoCopyWith<$Res> {
  factory _$$GeneralInfoImplCopyWith(
          _$GeneralInfoImpl value, $Res Function(_$GeneralInfoImpl) then) =
      __$$GeneralInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Unit> units,
      List<SocialContact> socialContacts,
      List<FinanceInfo> financeInfos,
      List<Consultation> consultations});
}

/// @nodoc
class __$$GeneralInfoImplCopyWithImpl<$Res>
    extends _$GeneralInfoCopyWithImpl<$Res, _$GeneralInfoImpl>
    implements _$$GeneralInfoImplCopyWith<$Res> {
  __$$GeneralInfoImplCopyWithImpl(
      _$GeneralInfoImpl _value, $Res Function(_$GeneralInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of GeneralInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? units = null,
    Object? socialContacts = null,
    Object? financeInfos = null,
    Object? consultations = null,
  }) {
    return _then(_$GeneralInfoImpl(
      units: null == units
          ? _value._units
          : units // ignore: cast_nullable_to_non_nullable
              as List<Unit>,
      socialContacts: null == socialContacts
          ? _value._socialContacts
          : socialContacts // ignore: cast_nullable_to_non_nullable
              as List<SocialContact>,
      financeInfos: null == financeInfos
          ? _value._financeInfos
          : financeInfos // ignore: cast_nullable_to_non_nullable
              as List<FinanceInfo>,
      consultations: null == consultations
          ? _value._consultations
          : consultations // ignore: cast_nullable_to_non_nullable
              as List<Consultation>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GeneralInfoImpl implements _GeneralInfo {
  const _$GeneralInfoImpl(
      {required final List<Unit> units,
      required final List<SocialContact> socialContacts,
      required final List<FinanceInfo> financeInfos,
      required final List<Consultation> consultations})
      : _units = units,
        _socialContacts = socialContacts,
        _financeInfos = financeInfos,
        _consultations = consultations;

  factory _$GeneralInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeneralInfoImplFromJson(json);

  final List<Unit> _units;
  @override
  List<Unit> get units {
    if (_units is EqualUnmodifiableListView) return _units;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_units);
  }

  final List<SocialContact> _socialContacts;
  @override
  List<SocialContact> get socialContacts {
    if (_socialContacts is EqualUnmodifiableListView) return _socialContacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_socialContacts);
  }

  final List<FinanceInfo> _financeInfos;
  @override
  List<FinanceInfo> get financeInfos {
    if (_financeInfos is EqualUnmodifiableListView) return _financeInfos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_financeInfos);
  }

  final List<Consultation> _consultations;
  @override
  List<Consultation> get consultations {
    if (_consultations is EqualUnmodifiableListView) return _consultations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_consultations);
  }

  @override
  String toString() {
    return 'GeneralInfo(units: $units, socialContacts: $socialContacts, financeInfos: $financeInfos, consultations: $consultations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeneralInfoImpl &&
            const DeepCollectionEquality().equals(other._units, _units) &&
            const DeepCollectionEquality()
                .equals(other._socialContacts, _socialContacts) &&
            const DeepCollectionEquality()
                .equals(other._financeInfos, _financeInfos) &&
            const DeepCollectionEquality()
                .equals(other._consultations, _consultations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_units),
      const DeepCollectionEquality().hash(_socialContacts),
      const DeepCollectionEquality().hash(_financeInfos),
      const DeepCollectionEquality().hash(_consultations));

  /// Create a copy of GeneralInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeneralInfoImplCopyWith<_$GeneralInfoImpl> get copyWith =>
      __$$GeneralInfoImplCopyWithImpl<_$GeneralInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GeneralInfoImplToJson(
      this,
    );
  }
}

abstract class _GeneralInfo implements GeneralInfo {
  const factory _GeneralInfo(
      {required final List<Unit> units,
      required final List<SocialContact> socialContacts,
      required final List<FinanceInfo> financeInfos,
      required final List<Consultation> consultations}) = _$GeneralInfoImpl;

  factory _GeneralInfo.fromJson(Map<String, dynamic> json) =
      _$GeneralInfoImpl.fromJson;

  @override
  List<Unit> get units;
  @override
  List<SocialContact> get socialContacts;
  @override
  List<FinanceInfo> get financeInfos;
  @override
  List<Consultation> get consultations;

  /// Create a copy of GeneralInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeneralInfoImplCopyWith<_$GeneralInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
