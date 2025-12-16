// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'landing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LandingResponse _$LandingResponseFromJson(Map<String, dynamic> json) {
  return _LandingResponse.fromJson(json);
}

/// @nodoc
mixin _$LandingResponse {
  List<Service> get featuredServices => throw _privateConstructorUsedError;
  List<Staff> get featuredStaff => throw _privateConstructorUsedError;
  List<Consultation> get featuredConsultations =>
      throw _privateConstructorUsedError;
  List<Article> get featuredArticles => throw _privateConstructorUsedError;

  /// Serializes this LandingResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LandingResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LandingResponseCopyWith<LandingResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LandingResponseCopyWith<$Res> {
  factory $LandingResponseCopyWith(
          LandingResponse value, $Res Function(LandingResponse) then) =
      _$LandingResponseCopyWithImpl<$Res, LandingResponse>;
  @useResult
  $Res call(
      {List<Service> featuredServices,
      List<Staff> featuredStaff,
      List<Consultation> featuredConsultations,
      List<Article> featuredArticles});
}

/// @nodoc
class _$LandingResponseCopyWithImpl<$Res, $Val extends LandingResponse>
    implements $LandingResponseCopyWith<$Res> {
  _$LandingResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LandingResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? featuredServices = null,
    Object? featuredStaff = null,
    Object? featuredConsultations = null,
    Object? featuredArticles = null,
  }) {
    return _then(_value.copyWith(
      featuredServices: null == featuredServices
          ? _value.featuredServices
          : featuredServices // ignore: cast_nullable_to_non_nullable
              as List<Service>,
      featuredStaff: null == featuredStaff
          ? _value.featuredStaff
          : featuredStaff // ignore: cast_nullable_to_non_nullable
              as List<Staff>,
      featuredConsultations: null == featuredConsultations
          ? _value.featuredConsultations
          : featuredConsultations // ignore: cast_nullable_to_non_nullable
              as List<Consultation>,
      featuredArticles: null == featuredArticles
          ? _value.featuredArticles
          : featuredArticles // ignore: cast_nullable_to_non_nullable
              as List<Article>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LandingResponseImplCopyWith<$Res>
    implements $LandingResponseCopyWith<$Res> {
  factory _$$LandingResponseImplCopyWith(_$LandingResponseImpl value,
          $Res Function(_$LandingResponseImpl) then) =
      __$$LandingResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Service> featuredServices,
      List<Staff> featuredStaff,
      List<Consultation> featuredConsultations,
      List<Article> featuredArticles});
}

/// @nodoc
class __$$LandingResponseImplCopyWithImpl<$Res>
    extends _$LandingResponseCopyWithImpl<$Res, _$LandingResponseImpl>
    implements _$$LandingResponseImplCopyWith<$Res> {
  __$$LandingResponseImplCopyWithImpl(
      _$LandingResponseImpl _value, $Res Function(_$LandingResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of LandingResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? featuredServices = null,
    Object? featuredStaff = null,
    Object? featuredConsultations = null,
    Object? featuredArticles = null,
  }) {
    return _then(_$LandingResponseImpl(
      featuredServices: null == featuredServices
          ? _value._featuredServices
          : featuredServices // ignore: cast_nullable_to_non_nullable
              as List<Service>,
      featuredStaff: null == featuredStaff
          ? _value._featuredStaff
          : featuredStaff // ignore: cast_nullable_to_non_nullable
              as List<Staff>,
      featuredConsultations: null == featuredConsultations
          ? _value._featuredConsultations
          : featuredConsultations // ignore: cast_nullable_to_non_nullable
              as List<Consultation>,
      featuredArticles: null == featuredArticles
          ? _value._featuredArticles
          : featuredArticles // ignore: cast_nullable_to_non_nullable
              as List<Article>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LandingResponseImpl implements _LandingResponse {
  const _$LandingResponseImpl(
      {required final List<Service> featuredServices,
      required final List<Staff> featuredStaff,
      required final List<Consultation> featuredConsultations,
      required final List<Article> featuredArticles})
      : _featuredServices = featuredServices,
        _featuredStaff = featuredStaff,
        _featuredConsultations = featuredConsultations,
        _featuredArticles = featuredArticles;

  factory _$LandingResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LandingResponseImplFromJson(json);

  final List<Service> _featuredServices;
  @override
  List<Service> get featuredServices {
    if (_featuredServices is EqualUnmodifiableListView)
      return _featuredServices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_featuredServices);
  }

  final List<Staff> _featuredStaff;
  @override
  List<Staff> get featuredStaff {
    if (_featuredStaff is EqualUnmodifiableListView) return _featuredStaff;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_featuredStaff);
  }

  final List<Consultation> _featuredConsultations;
  @override
  List<Consultation> get featuredConsultations {
    if (_featuredConsultations is EqualUnmodifiableListView)
      return _featuredConsultations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_featuredConsultations);
  }

  final List<Article> _featuredArticles;
  @override
  List<Article> get featuredArticles {
    if (_featuredArticles is EqualUnmodifiableListView)
      return _featuredArticles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_featuredArticles);
  }

  @override
  String toString() {
    return 'LandingResponse(featuredServices: $featuredServices, featuredStaff: $featuredStaff, featuredConsultations: $featuredConsultations, featuredArticles: $featuredArticles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LandingResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._featuredServices, _featuredServices) &&
            const DeepCollectionEquality()
                .equals(other._featuredStaff, _featuredStaff) &&
            const DeepCollectionEquality()
                .equals(other._featuredConsultations, _featuredConsultations) &&
            const DeepCollectionEquality()
                .equals(other._featuredArticles, _featuredArticles));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_featuredServices),
      const DeepCollectionEquality().hash(_featuredStaff),
      const DeepCollectionEquality().hash(_featuredConsultations),
      const DeepCollectionEquality().hash(_featuredArticles));

  /// Create a copy of LandingResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LandingResponseImplCopyWith<_$LandingResponseImpl> get copyWith =>
      __$$LandingResponseImplCopyWithImpl<_$LandingResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LandingResponseImplToJson(
      this,
    );
  }
}

abstract class _LandingResponse implements LandingResponse {
  const factory _LandingResponse(
      {required final List<Service> featuredServices,
      required final List<Staff> featuredStaff,
      required final List<Consultation> featuredConsultations,
      required final List<Article> featuredArticles}) = _$LandingResponseImpl;

  factory _LandingResponse.fromJson(Map<String, dynamic> json) =
      _$LandingResponseImpl.fromJson;

  @override
  List<Service> get featuredServices;
  @override
  List<Staff> get featuredStaff;
  @override
  List<Consultation> get featuredConsultations;
  @override
  List<Article> get featuredArticles;

  /// Create a copy of LandingResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LandingResponseImplCopyWith<_$LandingResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
