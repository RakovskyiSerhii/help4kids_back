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
      final firstName = body['firstName'] as String?;
      final lastName = body['lastName'] as String?;

      // Validate required fields
      if (email == null || password == null || firstName == null || lastName == null) {
        return ResponseHelpers.error(
          ApiErrors.validationError('Missing required fields: email, password, firstName, lastName'),
        );
      }

      // Validate email format
      if (!Validation.isValidEmail(email)) {
        return ResponseHelpers.error(
          ApiErrors.validationError('Invalid email format'),
        );
      }

      // Validate password strength
      if (!Validation.isValidPassword(password)) {
        return ResponseHelpers.error(
          ApiErrors.validationError('Password must be at least 8 characters long'),
        );
      }

      // Validate name fields
      if (!Validation.isNotEmpty(firstName)) {
        return ResponseHelpers.error(
          ApiErrors.validationError('First name cannot be empty'),
        );
      }

      if (!Validation.isNotEmpty(lastName)) {
        return ResponseHelpers.error(
          ApiErrors.validationError('Last name cannot be empty'),
        );
      }

      final success = await AuthService.registerUser(
        email: email.trim(),
        password: password,
        firstName: firstName.trim(),
        lastName: lastName.trim(),
      );

      if (!success) {
        return ResponseHelpers.error(
          ApiErrors.conflict('Registration failed. Email may already be in use.'),
        );
      }

      return ResponseHelpers.success({'message': 'User registered successfully'});
    } catch (e) {
      return ResponseHelpers.error(
        ApiErrors.internalError('Registration failed: ${e.toString()}'),
      );
    }
  }
  return ResponseHelpers.methodNotAllowed();
}