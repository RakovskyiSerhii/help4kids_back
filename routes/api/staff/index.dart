import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/staff_service.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.get) {
    try {
      final staffList = await StaffService.getAllStaff();
      return ResponseHelpers.success(
        {'staff': staffList.map((e) => e.toJson()).toList()},
      );
    } catch (e) {
      return ResponseHelpers.error(
        ApiErrors.internalError('Failed to fetch staff'),
      );
    }
  }
  return ResponseHelpers.methodNotAllowed();
}