// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceImpl _$$ServiceImplFromJson(Map<String, dynamic> json) =>
    _$ServiceImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      shortDescription: json['shortDescription'] as String,
      longDescription: json['longDescription'] as String?,
      image: json['image'] as String?,
      icon: json['icon'] as String,
      price: ServicePrice.fromJson(json['price'] as Map<String, dynamic>),
      duration: (json['duration'] as num?)?.toInt(),
      categoryId: json['categoryId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
    );

Map<String, dynamic> _$$ServiceImplToJson(_$ServiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'shortDescription': instance.shortDescription,
      'longDescription': instance.longDescription,
      'image': instance.image,
      'icon': instance.icon,
      'price': instance.price,
      'duration': instance.duration,
      'categoryId': instance.categoryId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
    };
