import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_material.freezed.dart';
part 'content_material.g.dart';

enum MaterialType {
  pdf,
  document,
  image,
  link,
  other,
}

@freezed
class ContentMaterial with _$ContentMaterial {
  const factory ContentMaterial({
    required String id,
    String? contentId, // NULL if attached to episode
    String? episodeId, // NULL if attached to content
    required MaterialType materialType,
    required String title,
    String? description,
    String? fileUrl, // For files stored on server
    String? externalUrl, // For external links
    int? fileSizeBytes,
    String? mimeType,
    @Default(0) int ordering,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
  }) = _ContentMaterial;

  factory ContentMaterial.fromJson(Map<String, dynamic> json) => _$ContentMaterialFromJson(json);
}

