import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

enum ServiceType { course, consultation, service }
enum OrderStatus { pending, paid, failed }

@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    required String userId,
    required String orderReference,
    required ServiceType serviceType,
    required String serviceId,
    required double amount,
    required OrderStatus status,
    required DateTime purchaseDate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}