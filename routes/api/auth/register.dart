import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/auth_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    final body = await context.request.json();
    final email = body['email'] as String?;
    final password = body['password'] as String?;
    final firstName = body['firstName'] as String?;
    final lastName = body['lastName'] as String?;

    if (email == null || password == null || firstName == null || lastName == null) {
      return Response.json(
        body: {'error': 'Missing required fields'},
        statusCode: 400,
      );
    }

    final success = await AuthService.registerUser(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );

    if (!success) {
      return Response.json(
        body: {'error': 'Registration failed. Email may already be in use.'},
        statusCode: 400,
      );
    }

    return Response.json(body: {'message': 'User registered successfully'});
  }
  return Response(statusCode: 405);
}