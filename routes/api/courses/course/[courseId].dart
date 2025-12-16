import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/course_service.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context, String courseId) async {
  // GET /api/courses/{courseId}: Fetch course details
  if (context.request.method == HttpMethod.get) {
    try {
      if (!Validation.isValidUuid(courseId)) {
        return ResponseHelpers.error(
          ApiErrors.validationError('Invalid course ID format'),
        );
      }
      final course = await CourseService.getCourseById(courseId);
      if (course == null) {
        return ResponseHelpers.error(ApiErrors.notFound('Course'));
      }
      return ResponseHelpers.success(course.toJson());
    } catch (e) {
      return ResponseHelpers.error(
        ApiErrors.internalError('Failed to fetch course'),
      );
    }
  }
  // PUT /api/courses/{courseId}: Update course details (admin/god only)
  else if (context.request.method == HttpMethod.put) {
    final handler = requireAdmin((context) async {
      try {
        if (!Validation.isValidUuid(courseId)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Invalid course ID format'),
          );
        }
        final body = await context.request.json() as Map<String, dynamic>;
        final success = await CourseService.updateCourse(courseId, body);
        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Update failed'),
          );
        }
        final updatedCourse = await CourseService.getCourseById(courseId);
        if (updatedCourse == null) {
          return ResponseHelpers.error(ApiErrors.notFound('Course'));
        }
        return ResponseHelpers.success(updatedCourse.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to update course'),
        );
      }
    });
    return handler(context);
  }
  // DELETE /api/courses/{courseId}: Delete a course (admin/god only)
  else if (context.request.method == HttpMethod.delete) {
    final handler = requireAdmin((context) async {
      try {
        if (!Validation.isValidUuid(courseId)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Invalid course ID format'),
          );
        }
        final success = await CourseService.deleteCourse(courseId);
        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Deletion failed'),
          );
        }
        return ResponseHelpers.success({'message': 'Course deleted successfully'});
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to delete course'),
        );
      }
    });
    return handler(context);
  }
  return ResponseHelpers.methodNotAllowed();
}