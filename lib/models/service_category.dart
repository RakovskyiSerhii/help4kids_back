import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_category.freezed.dart';
part 'service_category.g.dart';

@freezed
class ServiceCategory with _$ServiceCategory {
  const factory ServiceCategory({
    required String id,
    required String name,
    String? description,
    String? iconUrl, // New field for the icon URL
  }) = _ServiceCategory;

  factory ServiceCategory.fromJson(Map<String, dynamic> json) =>
      _$ServiceCategoryFromJson(json);
}