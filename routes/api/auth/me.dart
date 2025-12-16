import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/auth_service.dart';
import 'package:help4kids/middleware/auth_middleware.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context) async {
  // Apply auth middleware
  final handler = authMiddleware((context) async {
    if (context.request.method == HttpMethod.get) {
      try {
        // Get userId from context (set by auth middleware)
        final payload = context.read<JwtPayload>();
        final userId = payload.id;
        final user = await AuthService.getUserProfile(userId);
        if (user == null) {
          return ResponseHelpers.error(ApiErrors.notFound('User'));
        }
        // Don't expose password hash
        final userJson = user.toJson();
        userJson.remove('passwordHash');
        return ResponseHelpers.success(userJson);
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to fetch user profile'),
        );
      }
    }
    return ResponseHelpers.methodNotAllowed();
  });

  return handler(context);
}