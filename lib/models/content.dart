import 'package:freezed_annotation/freezed_annotation.dart';

part 'content.freezed.dart';
part 'content.g.dart';

enum ContentType {
  singleVideo,
  multiEpisode,
}

@freezed
class Content with _$Content {
  const factory Content({
    required String id,
    required String title,
    String? description,
    String? shortDescription,
    String? telegramGroupUrl,
    String? coverImageUrl,
    required ContentType contentType,
    // For single video content
    String? videoUrl,
    String? videoProvider,
    // Status
    @Default(false) bool featured,
    @Default(0) int ordering,
    @Default(true) bool isActive,
    // Metadata
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
    String? updatedBy,
  }) = _Content;

  factory Content.fromJson(Map<String, dynamic> json) => _$ContentFromJson(json);
}

