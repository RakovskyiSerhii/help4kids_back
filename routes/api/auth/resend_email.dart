import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/auth_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    final body = await context.request.json() as Map<String, dynamic>;
    final email = body['email'] as String?;
    if (email == null || email.isEmpty) {
      return Response.json(
          body: {'error': 'Email обов’язковий'}, statusCode: 400);
    }
    final result = await AuthService.resendVerificationEmail(email: email);
    if (result) {
      return Response.json(body: {'message': 'Лист підтвердження надіслано.'});
    }

    return Response.json(statusCode: 400);
  }
  return Response(statusCode: 405);
}
