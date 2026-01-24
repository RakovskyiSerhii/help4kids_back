import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/payment_service.dart';
import 'package:help4kids/services/order_service.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/models/payment.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context, String paymentId) async {
  // Require admin/god role for refunds
  final handler = requireAdmin((context) async {
    // Validate payment ID format
    if (!Validation.isValidUuid(paymentId)) {
      return ResponseHelpers.error(
        ApiErrors.validationError('Invalid payment ID format'),
      );
    }

    if (context.request.method == HttpMethod.post) {
      try {
        final body = await context.request.json() as Map<String, dynamic>;
        final refundAmount = body['amount'] as num?;
        final reason = body['reason'] as String?;

        // Get payment
        final payment = await PaymentService.getPaymentById(paymentId);
        if (payment == null) {
          return ResponseHelpers.error(ApiErrors.notFound('Payment'));
        }

        // Check if payment can be refunded
        if (payment.status != PaymentStatus.successful) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Only successful payments can be refunded'),
          );
        }

        // Determine refund amount (full or partial)
        final amountToRefund = refundAmount != null
            ? refundAmount.toDouble()
            : payment.amount;

        if (amountToRefund <= 0 || amountToRefund > payment.amount) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Invalid refund amount'),
          );
        }

        // TODO: Implement actual WayForPay refund API call
        // For now, we'll just update the payment status
        // In production, you would:
        // 1. Call WayForPay refund API
        // 2. Handle refund webhook
        // 3. Update payment and order status

        // Update payment status to refunded
        await PaymentService.updatePaymentStatus(
          paymentId: paymentId,
          status: PaymentStatus.refunded,
          rawPayload: {
            'refundAmount': amountToRefund,
            'reason': reason,
            'refundedAt': DateTime.now().toIso8601String(),
          },
        );

        // Update order status if full refund
        if (amountToRefund >= payment.amount) {
          // Mark order as refunded (you might want to add a refunded status to OrderStatus)
          // For now, we'll leave the order as paid but track refund in payment
        }

        final updatedPayment = await PaymentService.getPaymentById(paymentId);

        return ResponseHelpers.success({
          'payment': updatedPayment?.toJson(),
          'refundAmount': amountToRefund,
          'message': 'Refund processed successfully',
        });
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to process refund: ${e.toString()}'),
        );
      }
    }

    return ResponseHelpers.methodNotAllowed();
  });

  return handler(context);
}

