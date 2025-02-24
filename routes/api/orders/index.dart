import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/models/order.dart';
import 'package:help4kids/services/order_service.dart';
import 'package:uuid/uuid.dart';

Future<Response> onRequest(RequestContext context) async {
  // Handle POST /api/orders: Create a new order
  if (context.request.method == HttpMethod.post) {
    final body = await context.request.json();

    // In a real app, extract the authenticated user's ID from context (here we simulate)
    final userId = body['userId'] as String? ?? 'simulated-user-id';

    final serviceTypeString = body['serviceType'] as String?;
    final serviceId = body['serviceId'] as String?;
    final amount = body['amount'] as num?;

    if (serviceTypeString == null || serviceId == null || amount == null) {
      return Response.json(
        body: {'error': 'Missing required fields'},
        statusCode: 400,
      );
    }

    // Map provided string to ServiceType enum
    ServiceType? serviceType;
    switch (serviceTypeString.toLowerCase()) {
      case 'course':
        serviceType = ServiceType.course;
        break;
      case 'consultation':
        serviceType = ServiceType.consultation;
        break;
      case 'service':
        serviceType = ServiceType.service;
        break;
      default:
        return Response.json(
          body: {'error': 'Invalid service type'},
          statusCode: 400,
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

    return Response.json(body: order.toJson());
  }
  // Handle GET /api/orders/me: Retrieve orders for the authenticated user
  else if (context.request.method == HttpMethod.get) {
    // In a real app, get the userId from authentication middleware (simulated here)
    final userId = context.request.headers['x-user-id'] ?? 'simulated-user-id';
    final orders = await OrderService.getOrdersByUser(userId);

    return Response.json(
      body: {
        'orders': orders.map((order) => order.toJson()).toList(),
      },
    );
  }

  return Response(statusCode: 405);
}