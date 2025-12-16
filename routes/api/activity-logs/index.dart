import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/activity_log_service.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context) async {
  // Apply auth middleware and require god role
  final handler = requireGod((context) async {
    // Handle GET /api/activity-logs: Return all activity log entries.
    if (context.request.method == HttpMethod.get) {
      try {
        final logs = await ActivityLogService.getAllActivityLogs();
        return ResponseHelpers.success(
          {'activityLogs': logs.map((log) => log.toJson()).toList()},
        );
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to fetch activity logs'),
        );
      }
    }

    return ResponseHelpers.methodNotAllowed();
  });

  return handler(context);
}