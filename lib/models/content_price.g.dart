// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContentPriceImpl _$$ContentPriceImplFromJson(Map<String, dynamic> json) =>
    _$ContentPriceImpl(
      id: json['id'] as String,
      contentId: json['contentId'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'UAH',
      accessType: $enumDecode(_$AccessTypeEnumMap, json['accessType']),
      accessDurationMonths: (json['accessDurationMonths'] as num?)?.toInt(),
      description: json['description'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      ordering: (json['ordering'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ContentPriceImplToJson(_$ContentPriceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contentId': instance.contentId,
      'price': instance.price,
      'currency': instance.currency,
      'accessType': _$AccessTypeEnumMap[instance.accessType]!,
      'accessDurationMonths': instance.accessDurationMonths,
      'description': instance.description,
      'isDefault': instance.isDefault,
      'ordering': instance.ordering,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$AccessTypeEnumMap = {
  AccessType.lifetime: 'lifetime',
  AccessType.timeLimited: 'timeLimited',
};
