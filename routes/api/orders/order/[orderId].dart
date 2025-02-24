import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/order_service.dart';

Future<Response> onRequest(RequestContext context, String orderId) async {
  if (context.request.method == HttpMethod.get) {
    final order = await OrderService.getOrderById(orderId);
    if (order == null) {
      return Response.json(
        body: {'error': 'Order not found'},
        statusCode: 404,
      );
    }
    return Response.json(body: order.toJson());
  }
  return Response(statusCode: 405);
}