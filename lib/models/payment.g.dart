// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentImpl _$$PaymentImplFromJson(Map<String, dynamic> json) =>
    _$PaymentImpl(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      gateway: $enumDecode(_$PaymentGatewayEnumMap, json['gateway']),
      gatewayInvoiceId: json['gatewayInvoiceId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      rawGatewayPayload: json['rawGatewayPayload'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PaymentImplToJson(_$PaymentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'gateway': _$PaymentGatewayEnumMap[instance.gateway]!,
      'gatewayInvoiceId': instance.gatewayInvoiceId,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'rawGatewayPayload': instance.rawGatewayPayload,
    };

const _$PaymentGatewayEnumMap = {
  PaymentGateway.wayforpay: 'wayforpay',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.initiated: 'initiated',
  PaymentStatus.processing: 'processing',
  PaymentStatus.successful: 'successful',
  PaymentStatus.failed: 'failed',
  PaymentStatus.refunded: 'refunded',
};
