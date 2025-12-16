import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/order_service.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    try {
      final body = await context.request.json() as Map<String, dynamic>;

      // Validate the callback payload per WayForPay's requirements (e.g., signature verification)
      final result = await OrderService.handlePaymentCallback(body);
      if (result) {
        return ResponseHelpers.success({'status': 'success'});
      } else {
        return ResponseHelpers.error(
          ApiErrors.badRequest('Payment callback processing failed'),
        );
      }
    } catch (e) {
      return ResponseHelpers.error(
        ApiErrors.internalError('Failed to process payment callback'),
      );
    }
  }
  return ResponseHelpers.methodNotAllowed();
}