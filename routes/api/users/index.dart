import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/user_service.dart';

Future<Response> onRequest(RequestContext context) async {
  // Check that only admin or god can list users.
  final role = context.request.headers['x-role'] ?? 'customer';
  if (role != 'admin' && role != 'god') {
    return Response.json(
      body: {'error': 'Unauthorized'},
      statusCode: 403,
    );
  }

  if (context.request.method == HttpMethod.get) {
    final users = await UserService.getAllUsers();
    return Response.json(
      body: {'users': users.map((user) => user.toJson()).toList()},
    );
  }

  return Response(statusCode: 405);
}