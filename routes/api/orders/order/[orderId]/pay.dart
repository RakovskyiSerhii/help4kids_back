import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/order_service.dart';
import 'package:help4kids/services/payment_service.dart';
import 'package:help4kids/services/auth_service.dart';
import 'package:help4kids/middleware/auth_middleware.dart';
import 'package:help4kids/models/order.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context, String orderId) async {
  final handler = authMiddleware((context) async {
    // Validate order ID format
    if (!Validation.isValidUuid(orderId)) {
      return ResponseHelpers.error(
        ApiErrors.validationError('Invalid order ID format'),
      );
    }

    if (context.request.method == HttpMethod.post) {
      try {
        // Get authenticated user
        final payload = context.read<JwtPayload>();
        final userId = payload.id;

        // Get order and verify ownership
        final order = await OrderService.getOrderById(orderId);
        if (order == null) {
          return ResponseHelpers.error(ApiErrors.notFound('Order'));
        }

        if (order.userId != userId) {
          return ResponseHelpers.error(
            ApiErrors.forbidden('You can only pay for your own orders'),
          );
        }

        // Check if order is in a payable state
        if (order.status != OrderStatus.pending) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Order is not in a payable state'),
          );
        }

        // Get user profile for payment details
        final user = await AuthService.getUserProfile(userId);
        if (user == null) {
          return ResponseHelpers.error(ApiErrors.notFound('User'));
        }

        // Create payment record
        final payment = await PaymentService.createPayment(
          orderId: orderId,
          amount: order.amount,
          currency: 'UAH',
          gateway: PaymentGateway.wayforpay,
        );

        // Build WayForPay request
        // Determine product name based on service type
        String productName = 'Service';
        switch (order.serviceType) {
          case ServiceType.course:
            productName = 'Course';
            break;
          case ServiceType.consultation:
            productName = 'Consultation';
            break;
          case ServiceType.service:
            productName = 'Service';
            break;
        }

        // Build return URL (frontend should provide this or use default)
        final returnUrl = context.request.uri.queryParameters['returnUrl'] ??
            '${context.request.uri.scheme}://${context.request.uri.host}/payment-result?order_id=$orderId';

        // Build service URL (webhook endpoint)
        final serviceUrl = context.request.uri.queryParameters['serviceUrl'] ??
            '${context.request.uri.scheme}://${context.request.uri.host}/api/payments/wayforpay/callback';

        final wayforpayRequest = PaymentService.buildWayForPayRequest(
          orderReference: payment.gatewayInvoiceId,
          amount: order.amount,
          currency: 'UAH',
          returnUrl: returnUrl,
          serviceUrl: serviceUrl,
          productNames: [productName],
          productPrices: [order.amount],
          productCounts: [1],
          clientEmail: user.email,
          clientPhone: user.phone,
          clientFirstName: user.firstName,
          clientLastName: user.lastName,
        );

        return ResponseHelpers.success({
          'payment': payment.toJson(),
          'wayforpayRequest': wayforpayRequest,
          'redirectUrl': PaymentService.wayforpayApiUrl,
        });
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to initiate payment: ${e.toString()}'),
        );
      }
    }

    return ResponseHelpers.methodNotAllowed();
  });

  return handler(context);
}

