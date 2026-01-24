// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_price.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContentPrice _$ContentPriceFromJson(Map<String, dynamic> json) {
  return _ContentPrice.fromJson(json);
}

/// @nodoc
mixin _$ContentPrice {
  String get id => throw _privateConstructorUsedError;
  String get contentId => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  AccessType get accessType => throw _privateConstructorUsedError;
  int? get accessDurationMonths =>
      throw _privateConstructorUsedError; // NULL for lifetime
  String? get description => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  int get ordering => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ContentPrice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContentPrice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContentPriceCopyWith<ContentPrice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentPriceCopyWith<$Res> {
  factory $ContentPriceCopyWith(
          ContentPrice value, $Res Function(ContentPrice) then) =
      _$ContentPriceCopyWithImpl<$Res, ContentPrice>;
  @useResult
  $Res call(
      {String id,
      String contentId,
      double price,
      String currency,
      AccessType accessType,
      int? accessDurationMonths,
      String? description,
      bool isDefault,
      int ordering,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$ContentPriceCopyWithImpl<$Res, $Val extends ContentPrice>
    implements $ContentPriceCopyWith<$Res> {
  _$ContentPriceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContentPrice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? contentId = null,
    Object? price = null,
    Object? currency = null,
    Object? accessType = null,
    Object? accessDurationMonths = freezed,
    Object? description = freezed,
    Object? isDefault = null,
    Object? ordering = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      contentId: null == contentId
          ? _value.contentId
          : contentId // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      accessType: null == accessType
          ? _value.accessType
          : accessType // ignore: cast_nullable_to_non_nullable
              as AccessType,
      accessDurationMonths: freezed == accessDurationMonths
          ? _value.accessDurationMonths
          : accessDurationMonths // ignore: cast_nullable_to_non_nullable
              as int?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      ordering: null == ordering
          ? _value.ordering
          : ordering // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContentPriceImplCopyWith<$Res>
    implements $ContentPriceCopyWith<$Res> {
  factory _$$ContentPriceImplCopyWith(
          _$ContentPriceImpl value, $Res Function(_$ContentPriceImpl) then) =
      __$$ContentPriceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String contentId,
      double price,
      String currency,
      AccessType accessType,
      int? accessDurationMonths,
      String? description,
      bool isDefault,
      int ordering,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$ContentPriceImplCopyWithImpl<$Res>
    extends _$ContentPriceCopyWithImpl<$Res, _$ContentPriceImpl>
    implements _$$ContentPriceImplCopyWith<$Res> {
  __$$ContentPriceImplCopyWithImpl(
      _$ContentPriceImpl _value, $Res Function(_$ContentPriceImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContentPrice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? contentId = null,
    Object? price = null,
    Object? currency = null,
    Object? accessType = null,
    Object? accessDurationMonths = freezed,
    Object? description = freezed,
    Object? isDefault = null,
    Object? ordering = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ContentPriceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      contentId: null == contentId
          ? _value.contentId
          : contentId // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      accessType: null == accessType
          ? _value.accessType
          : accessType // ignore: cast_nullable_to_non_nullable
              as AccessType,
      accessDurationMonths: freezed == accessDurationMonths
          ? _value.accessDurationMonths
          : accessDurationMonths // ignore: cast_nullable_to_non_nullable
              as int?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      ordering: null == ordering
          ? _value.ordering
          : ordering // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContentPriceImpl implements _ContentPrice {
  const _$ContentPriceImpl(
      {required this.id,
      required this.contentId,
      required this.price,
      this.currency = 'UAH',
      required this.accessType,
      this.accessDurationMonths,
      this.description,
      this.isDefault = false,
      this.ordering = 0,
      required this.createdAt,
      required this.updatedAt});

  factory _$ContentPriceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContentPriceImplFromJson(json);

  @override
  final String id;
  @override
  final String contentId;
  @override
  final double price;
  @override
  @JsonKey()
  final String currency;
  @override
  final AccessType accessType;
  @override
  final int? accessDurationMonths;
// NULL for lifetime
  @override
  final String? description;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  @JsonKey()
  final int ordering;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ContentPrice(id: $id, contentId: $contentId, price: $price, currency: $currency, accessType: $accessType, accessDurationMonths: $accessDurationMonths, description: $description, isDefault: $isDefault, ordering: $ordering, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContentPriceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.contentId, contentId) ||
                other.contentId == contentId) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.accessType, accessType) ||
                other.accessType == accessType) &&
            (identical(other.accessDurationMonths, accessDurationMonths) ||
                other.accessDurationMonths == accessDurationMonths) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.ordering, ordering) ||
                other.ordering == ordering) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      contentId,
      price,
      currency,
      accessType,
      accessDurationMonths,
      description,
      isDefault,
      ordering,
      createdAt,
      updatedAt);

  /// Create a copy of ContentPrice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContentPriceImplCopyWith<_$ContentPriceImpl> get copyWith =>
      __$$ContentPriceImplCopyWithImpl<_$ContentPriceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContentPriceImplToJson(
      this,
    );
  }
}

abstract class _ContentPrice implements ContentPrice {
  const factory _ContentPrice(
      {required final String id,
      required final String contentId,
      required final double price,
      final String currency,
      required final AccessType accessType,
      final int? accessDurationMonths,
      final String? description,
      final bool isDefault,
      final int ordering,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ContentPriceImpl;

  factory _ContentPrice.fromJson(Map<String, dynamic> json) =
      _$ContentPriceImpl.fromJson;

  @override
  String get id;
  @override
  String get contentId;
  @override
  double get price;
  @override
  String get currency;
  @override
  AccessType get accessType;
  @override
  int? get accessDurationMonths; // NULL for lifetime
  @override
  String? get description;
  @override
  bool get isDefault;
  @override
  int get ordering;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of ContentPrice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContentPriceImplCopyWith<_$ContentPriceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
