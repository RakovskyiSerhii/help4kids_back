import 'package:freezed_annotation/freezed_annotation.dart';

part 'episode.freezed.dart';
part 'episode.g.dart';

@freezed
class Episode with _$Episode {
  const factory Episode({
    required String id,
    required String contentId,
    required String title,
    String? description,
    String? videoUrl,
    String? videoProvider,
    @Default(0) int ordering,
    int? durationSeconds,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
    String? updatedBy,
  }) = _Episode;

  factory Episode.fromJson(Map<String, dynamic> json) => _$EpisodeFromJson(json);
}

