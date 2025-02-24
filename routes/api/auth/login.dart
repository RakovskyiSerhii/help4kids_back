import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/auth_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    final body = await context.request.json();
    final email = body['email'] as String?;
    final password = body['password'] as String?;

    if (email == null || password == null) {
      return Response.json(
        body: {'error': 'Missing email or password'},
        statusCode: 400,
      );
    }

    final user = await AuthService.login(email, password);
    if (user == null) {
      return Response.json(
        body: {'error': 'Invalid credentials'},
        statusCode: 401,
      );
    }

    final token = AuthService.generateJwt(user);
    return Response.json(body: {'token': token});
  }
  return Response(statusCode: 405);
}