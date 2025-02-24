import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_category.freezed.dart';
part 'article_category.g.dart';

@freezed
class ArticleCategory with _$ArticleCategory {
  const factory ArticleCategory({
    required String id,
    required String title,
    String? description,
  }) = _ArticleCategory;

  factory ArticleCategory.fromJson(Map<String, dynamic> json) =>
      _$ArticleCategoryFromJson(json);
}