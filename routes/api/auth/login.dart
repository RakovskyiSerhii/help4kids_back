import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/auth_service.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    try {
      final body = await context.request.json() as Map<String, dynamic>;
      final email = body['email'] as String?;
      final password = body['password'] as String?;

      if (email == null || password == null) {
        return ResponseHelpers.error(
          ApiErrors.validationError('Missing email or password'),
        );
      }

      // Validate email format
      if (!Validation.isValidEmail(email)) {
        return ResponseHelpers.error(
          ApiErrors.validationError('Invalid email format'),
        );
      }

      final user = await AuthService.login(email.trim(), password);
      if (user == null) {
        return ResponseHelpers.error(
          ApiErrors.unauthorized('Invalid credentials'),
        );
      }

      final token = AuthService.generateJwt(user);
      return ResponseHelpers.success({'token': token});
    } catch (e) {
      return ResponseHelpers.error(
        ApiErrors.internalError('Login failed: ${e.toString()}'),
      );
    }
  }
  return ResponseHelpers.methodNotAllowed();
}