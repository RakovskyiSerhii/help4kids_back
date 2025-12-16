import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/staff_service.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context) async {
  // Apply auth middleware and require admin/god role
  final handler = requireAdmin((context) async {
    if (context.request.method == HttpMethod.post) {
      try {
        final body = await context.request.json() as Map<String, dynamic>;
        final name = body['name'] as String?;
        final content = body['content'] as String?;
        final featured = body['featured'] as bool? ?? false;

        if (name == null || !Validation.isNotEmpty(name)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Name is required and cannot be empty'),
          );
        }

        final success = await StaffService.createStaff(
          name: name.trim(),
          content: content?.trim(),
          featured: featured,
        );
        if (success) {
          return ResponseHelpers.success({'message': 'Staff member created successfully'});
        } else {
          return ResponseHelpers.error(
            ApiErrors.internalError('Failed to create staff member'),
          );
        }
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to create staff member'),
        );
      }
    }
    return ResponseHelpers.methodNotAllowed();
  });

  return handler(context);
}