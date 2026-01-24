// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Payment _$PaymentFromJson(Map<String, dynamic> json) {
  return _Payment.fromJson(json);
}

/// @nodoc
mixin _$Payment {
  String get id => throw _privateConstructorUsedError;
  String get orderId => throw _privateConstructorUsedError;
  PaymentGateway get gateway => throw _privateConstructorUsedError;
  String get gatewayInvoiceId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  PaymentStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get rawGatewayPayload =>
      throw _privateConstructorUsedError;

  /// Serializes this Payment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentCopyWith<Payment> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentCopyWith<$Res> {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) then) =
      _$PaymentCopyWithImpl<$Res, Payment>;
  @useResult
  $Res call(
      {String id,
      String orderId,
      PaymentGateway gateway,
      String gatewayInvoiceId,
      double amount,
      String currency,
      PaymentStatus status,
      DateTime createdAt,
      DateTime updatedAt,
      Map<String, dynamic>? rawGatewayPayload});
}

/// @nodoc
class _$PaymentCopyWithImpl<$Res, $Val extends Payment>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? gateway = null,
    Object? gatewayInvoiceId = null,
    Object? amount = null,
    Object? currency = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? rawGatewayPayload = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      gateway: null == gateway
          ? _value.gateway
          : gateway // ignore: cast_nullable_to_non_nullable
              as PaymentGateway,
      gatewayInvoiceId: null == gatewayInvoiceId
          ? _value.gatewayInvoiceId
          : gatewayInvoiceId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rawGatewayPayload: freezed == rawGatewayPayload
          ? _value.rawGatewayPayload
          : rawGatewayPayload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentImplCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$$PaymentImplCopyWith(
          _$PaymentImpl value, $Res Function(_$PaymentImpl) then) =
      __$$PaymentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String orderId,
      PaymentGateway gateway,
      String gatewayInvoiceId,
      double amount,
      String currency,
      PaymentStatus status,
      DateTime createdAt,
      DateTime updatedAt,
      Map<String, dynamic>? rawGatewayPayload});
}

/// @nodoc
class __$$PaymentImplCopyWithImpl<$Res>
    extends _$PaymentCopyWithImpl<$Res, _$PaymentImpl>
    implements _$$PaymentImplCopyWith<$Res> {
  __$$PaymentImplCopyWithImpl(
      _$PaymentImpl _value, $Res Function(_$PaymentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? gateway = null,
    Object? gatewayInvoiceId = null,
    Object? amount = null,
    Object? currency = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? rawGatewayPayload = freezed,
  }) {
    return _then(_$PaymentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      gateway: null == gateway
          ? _value.gateway
          : gateway // ignore: cast_nullable_to_non_nullable
              as PaymentGateway,
      gatewayInvoiceId: null == gatewayInvoiceId
          ? _value.gatewayInvoiceId
          : gatewayInvoiceId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rawGatewayPayload: freezed == rawGatewayPayload
          ? _value._rawGatewayPayload
          : rawGatewayPayload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentImpl implements _Payment {
  const _$PaymentImpl(
      {required this.id,
      required this.orderId,
      required this.gateway,
      required this.gatewayInvoiceId,
      required this.amount,
      required this.currency,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      final Map<String, dynamic>? rawGatewayPayload})
      : _rawGatewayPayload = rawGatewayPayload;

  factory _$PaymentImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentImplFromJson(json);

  @override
  final String id;
  @override
  final String orderId;
  @override
  final PaymentGateway gateway;
  @override
  final String gatewayInvoiceId;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final PaymentStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final Map<String, dynamic>? _rawGatewayPayload;
  @override
  Map<String, dynamic>? get rawGatewayPayload {
    final value = _rawGatewayPayload;
    if (value == null) return null;
    if (_rawGatewayPayload is EqualUnmodifiableMapView)
      return _rawGatewayPayload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Payment(id: $id, orderId: $orderId, gateway: $gateway, gatewayInvoiceId: $gatewayInvoiceId, amount: $amount, currency: $currency, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, rawGatewayPayload: $rawGatewayPayload)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.gateway, gateway) || other.gateway == gateway) &&
            (identical(other.gatewayInvoiceId, gatewayInvoiceId) ||
                other.gatewayInvoiceId == gatewayInvoiceId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._rawGatewayPayload, _rawGatewayPayload));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orderId,
      gateway,
      gatewayInvoiceId,
      amount,
      currency,
      status,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_rawGatewayPayload));

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentImplCopyWith<_$PaymentImpl> get copyWith =>
      __$$PaymentImplCopyWithImpl<_$PaymentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentImplToJson(
      this,
    );
  }
}

abstract class _Payment implements Payment {
  const factory _Payment(
      {required final String id,
      required final String orderId,
      required final PaymentGateway gateway,
      required final String gatewayInvoiceId,
      required final double amount,
      required final String currency,
      required final PaymentStatus status,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final Map<String, dynamic>? rawGatewayPayload}) = _$PaymentImpl;

  factory _Payment.fromJson(Map<String, dynamic> json) = _$PaymentImpl.fromJson;

  @override
  String get id;
  @override
  String get orderId;
  @override
  PaymentGateway get gateway;
  @override
  String get gatewayInvoiceId;
  @override
  double get amount;
  @override
  String get currency;
  @override
  PaymentStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  Map<String, dynamic>? get rawGatewayPayload;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentImplCopyWith<_$PaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
