// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServicePriceImpl _$$ServicePriceImplFromJson(Map<String, dynamic> json) =>
    _$ServicePriceImpl(
      price: (json['price'] as num).toDouble(),
      repeatPrice: (json['repeatPrice'] as num?)?.toDouble(),
      customRangePrices:
          (json['customRangePrices'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      customPriceString: json['customPriceString'] as String?,
    );

Map<String, dynamic> _$$ServicePriceImplToJson(_$ServicePriceImpl instance) =>
    <String, dynamic>{
      'price': instance.price,
      'repeatPrice': instance.repeatPrice,
      'customRangePrices': instance.customRangePrices,
      'customPriceString': instance.customPriceString,
    };
