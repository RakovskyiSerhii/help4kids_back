import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/auth_service.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    try {
      final body = await context.request.json() as Map<String, dynamic>;
      final email = body['email'] as String?;
      
      if (email == null || email.isEmpty) {
        return ResponseHelpers.error(
          ApiErrors.validationError('Email is required'),
        );
      }

      if (!Validation.isValidEmail(email)) {
        return ResponseHelpers.error(
          ApiErrors.validationError('Invalid email format'),
        );
      }

      final result = await AuthService.resendVerificationEmail(email: email.trim());
      if (result) {
        return ResponseHelpers.success(
          {'message': 'Verification email sent successfully.'},
        );
      }

      return ResponseHelpers.error(
        ApiErrors.badRequest('Failed to resend verification email. User may already be verified or does not exist.'),
      );
    } catch (e) {
      return ResponseHelpers.error(
        ApiErrors.internalError('Failed to resend verification email'),
      );
    }
  }
  return ResponseHelpers.methodNotAllowed();
}
