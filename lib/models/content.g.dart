// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContentImpl _$$ContentImplFromJson(Map<String, dynamic> json) =>
    _$ContentImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      shortDescription: json['shortDescription'] as String?,
      telegramGroupUrl: json['telegramGroupUrl'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      contentType: $enumDecode(_$ContentTypeEnumMap, json['contentType']),
      videoUrl: json['videoUrl'] as String?,
      videoProvider: json['videoProvider'] as String?,
      featured: json['featured'] as bool? ?? false,
      ordering: (json['ordering'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
    );

Map<String, dynamic> _$$ContentImplToJson(_$ContentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'shortDescription': instance.shortDescription,
      'telegramGroupUrl': instance.telegramGroupUrl,
      'coverImageUrl': instance.coverImageUrl,
      'contentType': _$ContentTypeEnumMap[instance.contentType]!,
      'videoUrl': instance.videoUrl,
      'videoProvider': instance.videoProvider,
      'featured': instance.featured,
      'ordering': instance.ordering,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
    };

const _$ContentTypeEnumMap = {
  ContentType.singleVideo: 'singleVideo',
  ContentType.multiEpisode: 'multiEpisode',
};
