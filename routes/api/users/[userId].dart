import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/user_service.dart';

Future<Response> onRequest(RequestContext context, String userId) async {
  // Check that only admin or god can manage users.
  final role = context.request.headers['x-role'] ?? 'customer';
  if (role != 'admin' && role != 'god') {
    return Response.json(
      body: {'error': 'Unauthorized'},
      statusCode: 403,
    );
  }

  // GET /api/users/{userId}: Retrieve user details.
  if (context.request.method == HttpMethod.get) {
    final user = await UserService.getUserById(userId);
    if (user == null) {
      return Response.json(
        body: {'error': 'User not found'},
        statusCode: 404,
      );
    }
    return Response.json(body: user.toJson());
  }

  // PUT /api/users/{userId}: Update user details.
  else if (context.request.method == HttpMethod.put) {
    final body = await context.request.json();
    final success = await UserService.updateUser(userId, body);
    if (!success) {
      return Response.json(
        body: {'error': 'Update failed'},
        statusCode: 400,
      );
    }
    final updatedUser = await UserService.getUserById(userId);
    return Response.json(body: updatedUser?.toJson() ?? {});
  }

  // DELETE /api/users/{userId}: Delete the user.
  else if (context.request.method == HttpMethod.delete) {
    final success = await UserService.deleteUser(userId);
    if (!success) {
      return Response.json(
        body: {'error': 'Deletion failed'},
        statusCode: 400,
      );
    }
    return Response.json(body: {'message': 'User deleted successfully'});
  }

  return Response(statusCode: 405);
}