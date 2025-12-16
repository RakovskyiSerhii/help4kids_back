import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/models/order.dart';
import 'package:help4kids/services/order_service.dart';
import 'package:help4kids/middleware/auth_middleware.dart';
import 'package:help4kids/constants/service_types.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';
import 'package:uuid/uuid.dart';

Future<Response> onRequest(RequestContext context) async {
  // Handle POST /api/orders: Create a new order (requires authentication)
  if (context.request.method == HttpMethod.post) {
    final handler = authMiddleware((context) async {
      try {
        final body = await context.request.json() as Map<String, dynamic>;
        
        // Get authenticated user's ID from JWT
        final payload = context.read<JwtPayload>();
        final userId = payload.id;

        final serviceTypeString = body['serviceType'] as String?;
        final serviceId = body['serviceId'] as String?;
        final amount = body['amount'] as num?;

        if (serviceTypeString == null || serviceId == null || amount == null) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Missing required fields: serviceType, serviceId, amount'),
          );
        }

        // Validate service type
        if (!ServiceTypes.all.contains(serviceTypeString.toLowerCase())) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Invalid service type. Must be one of: ${ServiceTypes.all.join(", ")}'),
          );
        }

        // Map provided string to ServiceType enum
        ServiceType? serviceType;
        switch (serviceTypeString.toLowerCase()) {
          case ServiceTypes.course:
            serviceType = ServiceType.course;
            break;
          case ServiceTypes.consultation:
            serviceType = ServiceType.consultation;
            break;
          case ServiceTypes.service:
            serviceType = ServiceType.service;
            break;
          default:
            return ResponseHelpers.error(
              ApiErrors.validationError('Invalid service type'),
            );
        }

        // Validate service ID format
        if (!Validation.isValidUuid(serviceId)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Invalid service ID format'),
          );
        }

        // Validate amount
        if (!Validation.isPositive(amount)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Amount must be positive'),
          );
        }

        // Generate or accept a provided orderReference
        final orderReference = body['orderReference'] as String? ?? Uuid().v4();

        final order = await OrderService.createOrder(
          userId: userId,
          orderReference: orderReference,
          serviceType: serviceType,
          serviceId: serviceId,
          amount: amount.toDouble(),
        );

        return ResponseHelpers.success(order.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to create order'),
        );
      }
    });

    return handler(context);
  }
  // Handle GET /api/orders: Retrieve orders for the authenticated user
  else if (context.request.method == HttpMethod.get) {
    final handler = authMiddleware((context) async {
      try {
        // Get authenticated user's ID from JWT
        final payload = context.read<JwtPayload>();
        final userId = payload.id;
        final orders = await OrderService.getOrdersByUser(userId);

        return ResponseHelpers.success(
          {'orders': orders.map((order) => order.toJson()).toList()},
        );
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to fetch orders'),
        );
      }
    });

    return handler(context);
  }

  return ResponseHelpers.methodNotAllowed();
}