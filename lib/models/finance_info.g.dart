// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FinanceInfoImpl _$$FinanceInfoImplFromJson(Map<String, dynamic> json) =>
    _$FinanceInfoImpl(
      id: json['id'] as String,
      tNumber: json['tNumber'] as String,
      name: json['name'] as String,
      officialAddress: json['officialAddress'] as String,
      actualAddress: json['actualAddress'] as String,
    );

Map<String, dynamic> _$$FinanceInfoImplToJson(_$FinanceInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tNumber': instance.tNumber,
      'name': instance.name,
      'officialAddress': instance.officialAddress,
      'actualAddress': instance.actualAddress,
    };
