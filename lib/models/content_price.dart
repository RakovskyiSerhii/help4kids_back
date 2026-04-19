import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_price.freezed.dart';
part 'content_price.g.dart';

enum AccessType {
  lifetime,
  timeLimited,
}

@freezed
class ContentPrice with _$ContentPrice {
  const factory ContentPrice({
    required String id,
    required String contentId,
    required double price,
    @Default('UAH') String currency,
    required AccessType accessType,
    int? accessDurationMonths, // NULL for lifetime
    String? description,
    @Default(false) bool isDefault,
    @Default(0) int ordering,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ContentPrice;

  factory ContentPrice.fromJson(Map<String, dynamic> json) => _$ContentPriceFromJson(json);
}

