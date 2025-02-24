import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/course_service.dart';

Future<Response> onRequest(RequestContext context, String courseId) async {
  // GET /api/courses/{courseId}: Fetch course details
  if (context.request.method == HttpMethod.get) {
    final course = await CourseService.getCourseById(courseId);
    if (course == null) {
      return Response.json(
        body: {'error': 'Course not found'},
        statusCode: 404,
      );
    }
    return Response.json(body: course.toJson());
  }
  // PUT /api/courses/{courseId}: Update course details (admin/god only)
  else if (context.request.method == HttpMethod.put) {
    final role = context.request.headers['x-role'] ?? 'customer';
    if (role != 'admin' && role != 'god') {
      return Response.json(
        body: {'error': 'Unauthorized'},
        statusCode: 403,
      );
    }
    final body = await context.request.json();
    final success = await CourseService.updateCourse(courseId, body);
    if (!success) {
      return Response.json(
        body: {'error': 'Update failed'},
        statusCode: 400,
      );
    }
    final updatedCourse = await CourseService.getCourseById(courseId);
    return Response.json(body: updatedCourse?.toJson() ?? {});
  }
  // DELETE /api/courses/{courseId}: Delete a course (admin/god only)
  else if (context.request.method == HttpMethod.delete) {
    final role = context.request.headers['x-role'] ?? 'customer';
    if (role != 'admin' && role != 'god') {
      return Response.json(
        body: {'error': 'Unauthorized'},
        statusCode: 403,
      );
    }
    final success = await CourseService.deleteCourse(courseId);
    if (!success) {
      return Response.json(
        body: {'error': 'Deletion failed'},
        statusCode: 400,
      );
    }
    return Response.json(body: {'message': 'Course deleted successfully'});
  }
  return Response(statusCode: 405);
}