// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      orderReference: json['orderReference'] as String,
      serviceType: $enumDecode(_$ServiceTypeEnumMap, json['serviceType']),
      serviceId: json['serviceId'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: $enumDecode(_$OrderStatusEnumMap, json['status']),
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'orderReference': instance.orderReference,
      'serviceType': _$ServiceTypeEnumMap[instance.serviceType]!,
      'serviceId': instance.serviceId,
      'amount': instance.amount,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'purchaseDate': instance.purchaseDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ServiceTypeEnumMap = {
  ServiceType.course: 'course',
  ServiceType.consultation: 'consultation',
  ServiceType.service: 'service',
};

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.paid: 'paid',
  OrderStatus.failed: 'failed',
};
