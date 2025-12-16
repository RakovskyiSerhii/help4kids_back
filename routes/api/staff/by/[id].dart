import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/staff_service.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method == HttpMethod.get) {
    try {
      if (!Validation.isValidUuid(id)) {
        return ResponseHelpers.error(
          ApiErrors.validationError('Invalid staff ID format'),
        );
      }
      final staff = await StaffService.getStaffById(id);
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
  return ResponseHelpers.methodNotAllowed();
}