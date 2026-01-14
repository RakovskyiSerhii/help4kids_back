import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:help4kids/models/service_price.dart';

part 'service.freezed.dart';
part 'service.g.dart';

@freezed
class Service with _$Service {
  const factory Service({
    required String id,
    required String title,
    required String shortDescription,
    String? longDescription,
    String? image,
    required String icon,
    required ServicePrice price,
    int? duration,
    required String categoryId,
    String? bookingId,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
    String? updatedBy,
  }) = _Service;

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);

  factory Service.fromRow(Map<String, dynamic> row) {
    // Parse JSON price field from DB into ServicePrice
    final dynamic rawPrice = row['price'];
    Map<String, dynamic> priceMap;
    if (rawPrice is String) {
      priceMap = rawPrice.isEmpty
          ? <String, dynamic>{}
          : Map<String, dynamic>.from(jsonDecode(rawPrice) as Map);
    } else if (rawPrice is Map) {
      priceMap = Map<String, dynamic>.from(rawPrice);
    } else {
      priceMap = <String, dynamic>{};
    }

    return Service(
      id: row['id']?.toString() ?? '',
      title: row['title']?.toString() ?? '',
      shortDescription: row['short_description']?.toString() ?? '',
      longDescription: row['long_description']?.toString(),
      image: row['image']?.toString(),
      icon: row['icon']?.toString() ?? '',
      price: ServicePrice(
        price: (priceMap['price'] as num?)?.toDouble() ?? 0.0,
        repeatPrice: (priceMap['repeatPrice'] as num?)?.toDouble(),
        customRangePrices: (priceMap['customRangePrices'] as Map?) != null
            ? (priceMap['customRangePrices'] as Map).map(
                (key, value) => MapEntry(
                  key.toString(),
                  (value as num).toDouble(),
                ),
              )
            : <String, double>{},
        customPriceString: priceMap['customPriceString']?.toString(),
      ),
      duration: row['duration'] as int?,
      categoryId: row['category_id']?.toString() ?? '',
      bookingId: row['booking_id']?.toString(),
      createdAt: DateTime.parse(row['created_at'].toString()),
      updatedAt: DateTime.parse(row['updated_at'].toString()),
      createdBy: row['created_by']?.toString(),
      updatedBy: row['updated_by']?.toString(),
    );
  }
}