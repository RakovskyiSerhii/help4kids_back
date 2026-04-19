import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/staff_service.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context, String staffId) async {
  final handler = requireAdmin((context) async {
    // Validate staff ID format
    if (!Validation.isValidUuid(staffId)) {
      return ResponseHelpers.error(
        ApiErrors.validationError('Invalid staff ID format'),
      );
    }

    // GET /api/staff/{staffId}: Get staff member
    if (context.request.method == HttpMethod.get) {
      try {
        final staff = await StaffService.getStaffById(staffId);
        if (staff == null) {
          return ResponseHelpers.error(ApiErrors.notFound('Staff'));
        }
        return ResponseHelpers.success(staff.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to fetch staff'),
        );
      }
    }

    // PUT /api/staff/{staffId}: Update staff member
    if (context.request.method == HttpMethod.put) {
      try {
        final body = await context.request.json() as Map<String, dynamic>;
        final updates = <String, dynamic>{};

        if (body.containsKey('name')) {
          final name = body['name'] as String?;
          if (name == null || !Validation.isNotEmpty(name)) {
            return ResponseHelpers.error(
              ApiErrors.validationError('Name is required and cannot be empty'),
            );
          }
          updates['name'] = name;
        }
        if (body.containsKey('content')) {
          updates['content'] = body['content'] as String?;
        }
        if (body.containsKey('photoUrl')) {
          updates['photoUrl'] = body['photoUrl'] as String?;
        }
        if (body.containsKey('featured')) {
          updates['featured'] = body['featured'] as bool? ?? false;
        }
        if (body.containsKey('ordering')) {
          updates['ordering'] = (body['ordering'] as num).toInt();
        }

        if (updates.isEmpty) {
          return ResponseHelpers.error(
            ApiErrors.validationError('No valid fields to update'),
          );
        }

        final success = await StaffService.updateStaff(staffId, updates);
        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Failed to update staff'),
          );
        }

        final updatedStaff = await StaffService.getStaffById(staffId);
        if (updatedStaff == null) {
          return ResponseHelpers.error(ApiErrors.notFound('Staff'));
        }
        return ResponseHelpers.success(updatedStaff.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to update staff'),
        );
      }
    }

    // DELETE /api/staff/{staffId}: Delete staff member
    if (context.request.method == HttpMethod.delete) {
      try {
        final success = await StaffService.deleteStaff(staffId);
        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Failed to delete staff'),
          );
        }
        // Return 204 No Content as per frontend requirements
        return Response(statusCode: 204);
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to delete staff'),
        );
      }
    }

    return ResponseHelpers.methodNotAllowed();
  });

  return handler(context);
}

