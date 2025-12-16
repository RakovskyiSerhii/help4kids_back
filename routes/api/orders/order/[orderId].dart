import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/order_service.dart';
import 'package:help4kids/middleware/auth_middleware.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context, String orderId) async {
  // Apply auth middleware
  final handler = authMiddleware((context) async {
    if (context.request.method == HttpMethod.get) {
      try {
        // Validate order ID format
        if (!Validation.isValidUuid(orderId)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Invalid order ID format'),
          );
        }

        // Get authenticated user's ID from JWT
        final payload = context.read<JwtPayload>();
        final userId = payload.id;

        final order = await OrderService.getOrderById(orderId);
        if (order == null) {
          return ResponseHelpers.error(ApiErrors.notFound('Order'));
        }

        // Ensure user can only access their own orders (unless admin)
        // Note: This assumes order.userId matches. In production, you might want to check role
        if (order.userId != userId) {
          return ResponseHelpers.error(ApiErrors.forbidden('You can only access your own orders'));
        }

        return ResponseHelpers.success(order.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to fetch order'),
        );
      }
    }
    return ResponseHelpers.methodNotAllowed();
  });

  return handler(context);
}