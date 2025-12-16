import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/order_service.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    try {
      final body = await context.request.json() as Map<String, dynamic>;
      final orderReference = body['orderReference'] as String?;
      if (orderReference == null || !Validation.isNotEmpty(orderReference)) {
        return ResponseHelpers.error(
          ApiErrors.validationError('Missing or empty orderReference'),
        );
      }
      final success = await OrderService.confirmPayment(orderReference);
      if (success) {
        return ResponseHelpers.success({'status': 'confirmed'});
      } else {
        return ResponseHelpers.error(
          ApiErrors.badRequest('Confirmation failed'),
        );
      }
    } catch (e) {
      return ResponseHelpers.error(
        ApiErrors.internalError('Failed to confirm payment'),
      );
    }
  }
  return ResponseHelpers.methodNotAllowed();
}