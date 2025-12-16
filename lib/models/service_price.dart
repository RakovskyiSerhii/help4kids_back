import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_price.freezed.dart';

part 'service_price.g.dart';

@freezed
class ServicePrice with _$ServicePrice {
  factory ServicePrice({
    required double price,
    double? repeatPrice,
    Map<String, double>? customRangePrices,
    String? customPriceString,
  }) = _ServicePrice;

  factory ServicePrice.fromJson(Map<String, dynamic> json) =>
      _$ServicePriceFromJson(json);
}
