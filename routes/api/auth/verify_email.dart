import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/auth_service.dart';

Future<Response> onRequest(RequestContext context) async {
  final token = context.request.url.queryParameters['token'];
  if (token == null || token.isEmpty) {
    return Response.json(
      body: {'error': 'Token is required'},
      statusCode: 400,
    );
  }
  final verified = await AuthService.verifyEmail(token);
  if (verified) {
    return Response.json(
      body: {'message': 'Email успішно підтверджено.'},
    );
  } else {
    return Response.json(
      body: {'error': 'Невірний або прострочений token.'},
      statusCode: 400,
    );
  }
}