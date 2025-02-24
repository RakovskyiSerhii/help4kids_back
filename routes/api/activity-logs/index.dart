import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/activity_log_service.dart';

Future<Response> onRequest(RequestContext context) async {
  // Check if the user has the "god" role.
  final role = context.request.headers['x-role'] ?? 'customer';
  if (role != 'god') {
    return Response.json(
      body: {'error': 'Unauthorized'},
      statusCode: 403,
    );
  }

  // Handle GET /api/activity-logs: Return all activity log entries.
  if (context.request.method == HttpMethod.get) {
    final logs = await ActivityLogService.getAllActivityLogs();
    return Response.json(
      body: {'activityLogs': logs.map((log) => log.toJson()).toList()},
    );
  }

  return Response(statusCode: 405);
}