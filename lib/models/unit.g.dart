// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UnitImpl _$$UnitImplFromJson(Map<String, dynamic> json) => _$UnitImpl(
      id: json['id'] as String,
      address: json['address'] as String,
      workingTime: Map<String, String?>.from(json['workingTime'] as Map),
      contactPhone: json['contactPhone'] as String,
      email: json['email'] as String,
      socialUrl: json['socialUrl'] as String?,
    );

Map<String, dynamic> _$$UnitImplToJson(_$UnitImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'workingTime': instance.workingTime,
      'contactPhone': instance.contactPhone,
      'email': instance.email,
      'socialUrl': instance.socialUrl,
    };
