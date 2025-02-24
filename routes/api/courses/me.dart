import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/course_service.dart';

Future<Response> onRequest(RequestContext context) async {
  // In production, obtain the authenticated user's ID from the context/middleware.
  final userId = context.request.headers['x-user-id'] ?? 'simulated-user-id';
  final courses = await CourseService.getPurchasedCourses(userId);
  return Response.json(
    body: {'courses': courses.map((c) => c.toJson()).toList()},
  );
}