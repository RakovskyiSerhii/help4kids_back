import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/auth_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    final body = await context.request.json();
    final currentPassword = body['currentPassword'] as String?;
    final newPassword = body['newPassword'] as String?;

    // In production, the user ID would be extracted from the auth token.
    final userId = context.request.headers['x-user-id'] ?? 'simulated-user-id';

    if (currentPassword == null || newPassword == null) {
      return Response.json(
        body: {'error': 'Missing required fields'},
        statusCode: 400,
      );
    }

    final success = await AuthService.changePassword(
      userId: userId,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    if (!success) {
      return Response.json(
        body: {'error': 'Password change failed. Current password may be incorrect.'},
        statusCode: 400,
      );
    }

    return Response.json(body: {'message': 'Password changed successfully'});
  }
  return Response(statusCode: 405);
}