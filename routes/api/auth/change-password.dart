import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/auth_service.dart';
import 'package:help4kids/middleware/auth_middleware.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context) async {
  // Apply auth middleware
  final handler = authMiddleware((context) async {
    if (context.request.method == HttpMethod.post) {
      try {
        final body = await context.request.json() as Map<String, dynamic>;
        final currentPassword = body['currentPassword'] as String?;
        final newPassword = body['newPassword'] as String?;

        // Get userId from context (set by auth middleware)
        final payload = context.read<JwtPayload>();
        final userId = payload.id;

        if (currentPassword == null || newPassword == null) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Missing required fields: currentPassword, newPassword'),
          );
        }

        // Validate password strength
        if (!Validation.isValidPassword(newPassword)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('New password must be at least 8 characters long'),
          );
        }

        final success = await AuthService.changePassword(
          userId: userId,
          currentPassword: currentPassword,
          newPassword: newPassword,
        );

        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Password change failed. Current password may be incorrect.'),
          );
        }

        return ResponseHelpers.success({'message': 'Password changed successfully'});
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to change password'),
        );
      }
    }
    return ResponseHelpers.methodNotAllowed();
  });

  return handler(context);
}