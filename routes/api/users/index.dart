import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/user_service.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context) async {
  // Apply auth middleware and require admin/god role
  final handler = requireAdmin((context) async {
    if (context.request.method == HttpMethod.get) {
      try {
        final users = await UserService.getAllUsers();
        // Remove password hashes from response
        final usersJson = users.map((user) {
          final userJson = user.toJson();
          userJson.remove('passwordHash');
          return userJson;
        }).toList();
        return ResponseHelpers.success({'users': usersJson});
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to fetch users'),
        );
      }
    }
    return ResponseHelpers.methodNotAllowed();
  });

  return handler(context);
}