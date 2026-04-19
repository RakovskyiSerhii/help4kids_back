import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/content_service.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context, String materialId) async {
  final handler = requireAdmin((context) async {
    // Validate material ID format
    if (!Validation.isValidUuid(materialId)) {
      return ResponseHelpers.error(
        ApiErrors.validationError('Invalid material ID format'),
      );
    }

    // DELETE /api/admin/materials/{materialId} - Delete material
    if (context.request.method == HttpMethod.delete) {
      try {
        final success = await ContentService.deleteContentMaterial(materialId);
        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Failed to delete material'),
          );
        }
        return ResponseHelpers.success({'message': 'Material deleted successfully'});
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to delete material'),
        );
      }
    }

    return ResponseHelpers.methodNotAllowed();
  });

  return handler(context);
}

