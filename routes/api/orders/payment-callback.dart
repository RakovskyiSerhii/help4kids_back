import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/order_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    final body = await context.request.json();

    // Validate the callback payload per WayForPay's requirements (e.g., signature verification)
    final result = await OrderService.handlePaymentCallback(body);
    if (result) {
      return Response.json(body: {'status': 'success'});
    } else {
      return Response.json(body: {'status': 'error'}, statusCode: 400);
    }
  }
  return Response(statusCode: 405);
}