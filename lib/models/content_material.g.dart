// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_material.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContentMaterialImpl _$$ContentMaterialImplFromJson(
        Map<String, dynamic> json) =>
    _$ContentMaterialImpl(
      id: json['id'] as String,
      contentId: json['contentId'] as String?,
      episodeId: json['episodeId'] as String?,
      materialType: $enumDecode(_$MaterialTypeEnumMap, json['materialType']),
      title: json['title'] as String,
      description: json['description'] as String?,
      fileUrl: json['fileUrl'] as String?,
      externalUrl: json['externalUrl'] as String?,
      fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt(),
      mimeType: json['mimeType'] as String?,
      ordering: (json['ordering'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
    );

Map<String, dynamic> _$$ContentMaterialImplToJson(
        _$ContentMaterialImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contentId': instance.contentId,
      'episodeId': instance.episodeId,
      'materialType': _$MaterialTypeEnumMap[instance.materialType]!,
      'title': instance.title,
      'description': instance.description,
      'fileUrl': instance.fileUrl,
      'externalUrl': instance.externalUrl,
      'fileSizeBytes': instance.fileSizeBytes,
      'mimeType': instance.mimeType,
      'ordering': instance.ordering,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
    };

const _$MaterialTypeEnumMap = {
  MaterialType.pdf: 'pdf',
  MaterialType.document: 'document',
  MaterialType.image: 'image',
  MaterialType.link: 'link',
  MaterialType.other: 'other',
};
