import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

enum PaymentStatus {
  initiated,
  processing,
  successful,
  failed,
  refunded,
}

enum PaymentGateway {
  wayforpay,
}

@freezed
class Payment with _$Payment {
  const factory Payment({
    required String id,
    required String orderId,
    required PaymentGateway gateway,
    required String gatewayInvoiceId,
    required double amount,
    required String currency,
    required PaymentStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    Map<String, dynamic>? rawGatewayPayload,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);
}

