import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/course_service.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context) async {
  // GET /api/courses: List all courses
  if (context.request.method == HttpMethod.get) {
    try {
      final courses = await CourseService.getAllCourses();
      return ResponseHelpers.success(
        {'courses': courses.map((c) => c.toJson()).toList()},
      );
    } catch (e) {
      return ResponseHelpers.error(
        ApiErrors.internalError('Failed to fetch courses'),
      );
    }
  }
  // POST /api/courses: Create a new course (admin/god only)
  else if (context.request.method == HttpMethod.post) {
    final handler = requireAdmin((context) async {
      try {
        final body = await context.request.json() as Map<String, dynamic>;

        final title = body['title'] as String?;
        final shortDescription = body['shortDescription'] as String?;
        final contentUrl = body['contentUrl'] as String?;
        final icon = body['icon'] as String?;
        final price = body['price'] as num?;

        if (title == null || shortDescription == null || contentUrl == null || icon == null || price == null) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Missing required fields: title, shortDescription, contentUrl, icon, price'),
          );
        }

        // Validate fields
        if (!Validation.isNotEmpty(title)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Title cannot be empty'),
          );
        }

        if (!Validation.isPositive(price)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Price must be positive'),
          );
        }

        final longDescription = body['longDescription'] as String?;
        final image = body['image'] as String?;
        final duration = body['duration'] as int?;

        if (duration != null && !Validation.isPositive(duration)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Duration must be positive'),
          );
        }

        final course = await CourseService.createCourse(
          title: title.trim(),
          shortDescription: shortDescription.trim(),
          longDescription: longDescription?.trim(),
          image: image?.trim(),
          icon: icon.trim(),
          price: price.toDouble(),
          duration: duration,
          contentUrl: contentUrl.trim(),
        );
        return ResponseHelpers.success(course.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to create course'),
        );
      }
    });

    return handler(context);
  }
  return ResponseHelpers.methodNotAllowed();
}