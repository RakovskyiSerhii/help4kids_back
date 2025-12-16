import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/auth_service.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.get) {
    try {
      final token = context.request.url.queryParameters['token'];
      if (token == null || token.isEmpty) {
        return ResponseHelpers.error(
          ApiErrors.validationError('Token is required'),
        );
      }

      final verified = await AuthService.verifyEmail(token);
      if (verified) {
        return ResponseHelpers.success(
          {'message': 'Email successfully verified.'},
        );
      } else {
        return ResponseHelpers.error(
          ApiErrors.badRequest('Invalid or expired token.'),
        );
      }
    } catch (e) {
      return ResponseHelpers.error(
        ApiErrors.internalError('Failed to verify email'),
      );
    }
  }
  return ResponseHelpers.methodNotAllowed();
}