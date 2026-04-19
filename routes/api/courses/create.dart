import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/course_service.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

// Route alias: /api/courses/create -> /api/courses (POST)
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return ResponseHelpers.methodNotAllowed();
  }
  
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

      // Enhanced validation per frontend requirements
      if (title.trim().length < 3 || title.trim().length > 200) {
        return ResponseHelpers.error(
          ApiErrors.validationError('Title must be between 3 and 200 characters'),
        );
      }

      if (shortDescription.trim().length < 10 || shortDescription.trim().length > 500) {
        return ResponseHelpers.error(
          ApiErrors.validationError('Short description must be between 10 and 500 characters'),
        );
      }

      final longDescription = body['longDescription'] as String?;
      if (longDescription != null && longDescription.trim().length > 5000) {
        return ResponseHelpers.error(
          ApiErrors.validationError('Long description must not exceed 5000 characters'),
        );
      }

      if (!Validation.isPositive(price)) {
        return ResponseHelpers.error(
          ApiErrors.validationError('Price must be positive'),
        );
      }

      // Validate contentUrl is a valid URL
      try {
        final uri = Uri.parse(contentUrl);
        if (!uri.hasScheme || (!uri.scheme.startsWith('http'))) {
          return ResponseHelpers.error(
            ApiErrors.validationError('contentUrl must be a valid URL'),
          );
        }
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.validationError('contentUrl must be a valid URL'),
        );
      }

      final image = body['image'] as String?;
      final duration = body['duration'] as int?;

      if (duration != null && !Validation.isPositive(duration)) {
        return ResponseHelpers.error(
          ApiErrors.validationError('Duration must be positive'),
        );
      }

      final payload = context.read<JwtPayload>();
      final featured = body['featured'] as bool? ?? false;
      
      final course = await CourseService.createCourse(
        title: title.trim(),
        shortDescription: shortDescription.trim(),
        longDescription: longDescription?.trim(),
        image: image?.trim(),
        icon: icon.trim() == '' ? 'default' : icon.trim(),
        price: price.toDouble(),
        duration: duration,
        contentUrl: contentUrl.trim(),
        featured: featured,
        createdBy: payload.id,
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
