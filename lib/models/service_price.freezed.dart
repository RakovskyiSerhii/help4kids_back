// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_price.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServicePrice _$ServicePriceFromJson(Map<String, dynamic> json) {
  return _ServicePrice.fromJson(json);
}

/// @nodoc
mixin _$ServicePrice {
  double get price => throw _privateConstructorUsedError;
  double? get repeatPrice => throw _privateConstructorUsedError;
  Map<String, double>? get customRangePrices =>
      throw _privateConstructorUsedError;
  String? get customPriceString => throw _privateConstructorUsedError;

  /// Serializes this ServicePrice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServicePrice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServicePriceCopyWith<ServicePrice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServicePriceCopyWith<$Res> {
  factory $ServicePriceCopyWith(
          ServicePrice value, $Res Function(ServicePrice) then) =
      _$ServicePriceCopyWithImpl<$Res, ServicePrice>;
  @useResult
  $Res call(
      {double price,
      double? repeatPrice,
      Map<String, double>? customRangePrices,
      String? customPriceString});
}

/// @nodoc
class _$ServicePriceCopyWithImpl<$Res, $Val extends ServicePrice>
    implements $ServicePriceCopyWith<$Res> {
  _$ServicePriceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServicePrice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? price = null,
    Object? repeatPrice = freezed,
    Object? customRangePrices = freezed,
    Object? customPriceString = freezed,
  }) {
    return _then(_value.copyWith(
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      repeatPrice: freezed == repeatPrice
          ? _value.repeatPrice
          : repeatPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      customRangePrices: freezed == customRangePrices
          ? _value.customRangePrices
          : customRangePrices // ignore: cast_nullable_to_non_nullable
              as Map<String, double>?,
      customPriceString: freezed == customPriceString
          ? _value.customPriceString
          : customPriceString // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServicePriceImplCopyWith<$Res>
    implements $ServicePriceCopyWith<$Res> {
  factory _$$ServicePriceImplCopyWith(
          _$ServicePriceImpl value, $Res Function(_$ServicePriceImpl) then) =
      __$$ServicePriceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double price,
      double? repeatPrice,
      Map<String, double>? customRangePrices,
      String? customPriceString});
}

/// @nodoc
class __$$ServicePriceImplCopyWithImpl<$Res>
    extends _$ServicePriceCopyWithImpl<$Res, _$ServicePriceImpl>
    implements _$$ServicePriceImplCopyWith<$Res> {
  __$$ServicePriceImplCopyWithImpl(
      _$ServicePriceImpl _value, $Res Function(_$ServicePriceImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServicePrice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? price = null,
    Object? repeatPrice = freezed,
    Object? customRangePrices = freezed,
    Object? customPriceString = freezed,
  }) {
    return _then(_$ServicePriceImpl(
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      repeatPrice: freezed == repeatPrice
          ? _value.repeatPrice
          : repeatPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      customRangePrices: freezed == customRangePrices
          ? _value._customRangePrices
          : customRangePrices // ignore: cast_nullable_to_non_nullable
              as Map<String, double>?,
      customPriceString: freezed == customPriceString
          ? _value.customPriceString
          : customPriceString // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServicePriceImpl implements _ServicePrice {
  _$ServicePriceImpl(
      {required this.price,
      this.repeatPrice,
      final Map<String, double>? customRangePrices,
      this.customPriceString})
      : _customRangePrices = customRangePrices;

  factory _$ServicePriceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServicePriceImplFromJson(json);

  @override
  final double price;
  @override
  final double? repeatPrice;
  final Map<String, double>? _customRangePrices;
  @override
  Map<String, double>? get customRangePrices {
    final value = _customRangePrices;
    if (value == null) return null;
    if (_customRangePrices is EqualUnmodifiableMapView)
      return _customRangePrices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? customPriceString;

  @override
  String toString() {
    return 'ServicePrice(price: $price, repeatPrice: $repeatPrice, customRangePrices: $customRangePrices, customPriceString: $customPriceString)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServicePriceImpl &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.repeatPrice, repeatPrice) ||
                other.repeatPrice == repeatPrice) &&
            const DeepCollectionEquality()
                .equals(other._customRangePrices, _customRangePrices) &&
            (identical(other.customPriceString, customPriceString) ||
                other.customPriceString == customPriceString));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      price,
      repeatPrice,
      const DeepCollectionEquality().hash(_customRangePrices),
      customPriceString);

  /// Create a copy of ServicePrice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServicePriceImplCopyWith<_$ServicePriceImpl> get copyWith =>
      __$$ServicePriceImplCopyWithImpl<_$ServicePriceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServicePriceImplToJson(
      this,
    );
  }
}

abstract class _ServicePrice implements ServicePrice {
  factory _ServicePrice(
      {required final double price,
      final double? repeatPrice,
      final Map<String, double>? customRangePrices,
      final String? customPriceString}) = _$ServicePriceImpl;

  factory _ServicePrice.fromJson(Map<String, dynamic> json) =
      _$ServicePriceImpl.fromJson;

  @override
  double get price;
  @override
  double? get repeatPrice;
  @override
  Map<String, double>? get customRangePrices;
  @override
  String? get customPriceString;

  /// Create a copy of ServicePrice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServicePriceImplCopyWith<_$ServicePriceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
