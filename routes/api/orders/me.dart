import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/order_service.dart';

Future<Response> onRequest(RequestContext context) async {
  // In a real-world scenario, an authentication middleware would provide the user id.
  // Here we simulate it using a header or default value.
  final userId = context.request.headers['x-user-id'] ?? 'simulated-user-id';

  final orders = await OrderService.getOrdersByUser(userId);

  return Response.json(
    body: {
      'orders': orders.map((order) => order.toJson()).toList(),
    },
  );
}