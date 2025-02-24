import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/order_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    final body = await context.request.json();
    final orderReference = body['orderReference'] as String?;
    if (orderReference == null) {
      return Response.json(
        body: {'error': 'Missing orderReference'},
        statusCode: 400,
      );
    }
    final success = await OrderService.confirmPayment(orderReference);
    if (success) {
      return Response.json(body: {'status': 'confirmed'});
    } else {
      return Response.json(body: {'error': 'Confirmation failed'}, statusCode: 400);
    }
  }
  return Response(statusCode: 405);
}