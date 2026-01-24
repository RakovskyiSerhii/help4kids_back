import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/payment_service.dart';
import 'package:help4kids/services/order_service.dart';
import 'package:help4kids/models/payment.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    try {
      final body = await context.request.json() as Map<String, dynamic>;

      // Extract signature for verification
      final receivedSignature = body['merchantSignature'] as String?;
      if (receivedSignature == null) {
        return ResponseHelpers.error(
          ApiErrors.badRequest('Missing merchant signature'),
        );
      }

      // Remove signature from body for verification
      final bodyForVerification = Map<String, dynamic>.from(body);
      bodyForVerification.remove('merchantSignature');

      // Verify signature
      if (!PaymentService.verifyWayForPaySignature(
        bodyForVerification,
        receivedSignature,
      )) {
        return ResponseHelpers.error(
          ApiErrors.unauthorized('Invalid signature'),
        );
      }

      // Extract payment details
      final orderReference = body['orderReference'] as String?;
      final wayforpayStatus = body['reason'] as String? ?? body['transactionStatus'] as String?;
      final amount = body['amount'] as num?;
      final currency = body['currency'] as String?;

      if (orderReference == null) {
        return ResponseHelpers.error(
          ApiErrors.badRequest('Missing orderReference'),
        );
      }

      // Find payment by gateway invoice ID
      final payment = await PaymentService.getPaymentByGatewayInvoiceId(
        orderReference,
      );

      if (payment == null) {
        return ResponseHelpers.error(
          ApiErrors.notFound('Payment not found'),
        );
      }

      // Validate amount and currency match
      if (amount != null && amount != payment.amount) {
        return ResponseHelpers.error(
          ApiErrors.badRequest('Amount mismatch'),
        );
      }

      if (currency != null && currency != payment.currency) {
        return ResponseHelpers.error(
          ApiErrors.badRequest('Currency mismatch'),
        );
      }

      // Map WayForPay status to PaymentStatus
      final paymentStatus = wayforpayStatus != null
          ? PaymentService.mapWayForPayStatus(wayforpayStatus)
          : PaymentStatus.processing;

      // Update payment status (idempotent - check if already processed)
      if (payment.status != paymentStatus) {
        await PaymentService.updatePaymentStatus(
          paymentId: payment.id,
          status: paymentStatus,
          rawPayload: body,
        );

        // Update order status based on payment status
        if (paymentStatus == PaymentStatus.successful) {
          await OrderService.confirmPayment(payment.gatewayInvoiceId);
        } else if (paymentStatus == PaymentStatus.failed) {
          // Order remains in pending state for failed payments
          // Could optionally update to 'failed' if needed
        }
      }

      // Return success response to WayForPay
      // WayForPay expects a specific response format
      return Response.json(
        statusCode: 200,
        body: {
          'orderReference': orderReference,
          'status': 'accept',
          'time': DateTime.now().millisecondsSinceEpoch,
        },
      );
    } catch (e) {
      // Log error but return success to prevent WayForPay retries
      // In production, you might want to log this to a monitoring system
      return Response.json(
        statusCode: 200,
        body: {
          'status': 'accept',
          'error': 'Processing error: ${e.toString()}',
        },
      );
    }
  }

  return ResponseHelpers.methodNotAllowed();
}

