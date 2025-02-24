import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/auth_service.dart';

Future<Response> onRequest(RequestContext context) async {
  // In production, the user ID should be extracted from the auth token.
  final userId = context.request.headers['x-user-id'] ?? 'simulated-user-id';

  if (context.request.method == HttpMethod.get) {
    final user = await AuthService.getUserProfile(userId);
    if (user == null) {
      return Response.json(
        body: {'error': 'User not found'},
        statusCode: 404,
      );
    }
    return Response.json(body: user.toJson());
  }
  return Response(statusCode: 405);
}