import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/user_service.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context, String userId) async {
  // Apply auth middleware and require admin/god role
  final handler = requireAdmin((context) async {
    // Validate userId format
    if (!Validation.isValidUuid(userId)) {
      return ResponseHelpers.error(
        ApiErrors.validationError('Invalid user ID format'),
      );
    }

    // GET /api/users/{userId}: Retrieve user details.
    if (context.request.method == HttpMethod.get) {
      try {
        final user = await UserService.getUserById(userId);
        if (user == null) {
          return ResponseHelpers.error(ApiErrors.notFound('User'));
        }
        final userJson = user.toJson();
        userJson.remove('passwordHash');
        return ResponseHelpers.success(userJson);
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to fetch user'),
        );
      }
    }

    // PUT /api/users/{userId}: Update user details.
    else if (context.request.method == HttpMethod.put) {
      try {
        final body = await context.request.json() as Map<String, dynamic>;
        final success = await UserService.updateUser(userId, body);
        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Update failed'),
          );
        }
        final updatedUser = await UserService.getUserById(userId);
        if (updatedUser == null) {
          return ResponseHelpers.error(ApiErrors.notFound('User'));
        }
        final userJson = updatedUser.toJson();
        userJson.remove('passwordHash');
        return ResponseHelpers.success(userJson);
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to update user'),
        );
      }
    }

    // DELETE /api/users/{userId}: Delete the user.
    else if (context.request.method == HttpMethod.delete) {
      try {
        final success = await UserService.deleteUser(userId);
        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Deletion failed'),
          );
        }
        return ResponseHelpers.success({'message': 'User deleted successfully'});
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to delete user'),
        );
      }
    }

    return ResponseHelpers.methodNotAllowed();
  });

  return handler(context);
}