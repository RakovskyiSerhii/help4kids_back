import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/course_service.dart';
import 'package:help4kids/middleware/auth_middleware.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context) async {
  // Apply auth middleware
  final handler = authMiddleware((context) async {
    try {
      // Get authenticated user's ID from JWT
      final payload = context.read<JwtPayload>();
      final userId = payload.id;
      final courses = await CourseService.getPurchasedCourses(userId);
      return ResponseHelpers.success(
        {'courses': courses.map((c) => c.toJson()).toList()},
      );
    } catch (e) {
      return ResponseHelpers.error(
        ApiErrors.internalError('Failed to fetch purchased courses'),
      );
    }
  });

  return handler(context);
}