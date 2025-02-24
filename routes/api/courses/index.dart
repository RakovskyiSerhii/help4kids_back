import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/course_service.dart';

Future<Response> onRequest(RequestContext context) async {
  // GET /api/courses: List all courses
  if (context.request.method == HttpMethod.get) {
    final courses = await CourseService.getAllCourses();
    return Response.json(
      body: {'courses': courses.map((c) => c.toJson()).toList()},
    );
  }
  // POST /api/courses: Create a new course (admin/god only)
  else if (context.request.method == HttpMethod.post) {
    // Simulated authorization check (in production, use middleware)
    final role = context.request.headers['x-role'] ?? 'customer';
    if (role != 'admin' && role != 'god') {
      return Response.json(
        body: {'error': 'Unauthorized'},
        statusCode: 403,
      );
    }
    final body = await context.request.json();

    // Validate required fields
    final title = body['title'] as String?;
    final shortDescription = body['shortDescription'] as String?;
    final contentUrl = body['contentUrl'] as String?;
    final icon = body['icon'] as String?;
    final price = body['price'] as num?;
    if (title == null || shortDescription == null || contentUrl == null || icon == null || price == null) {
      return Response.json(
        body: {'error': 'Missing required fields'},
        statusCode: 400,
      );
    }
    // Optional fields
    final longDescription = body['longDescription'] as String?;
    final image = body['image'] as String?;
    final duration = body['duration'] as int?;

    final course = await CourseService.createCourse(
      title: title,
      shortDescription: shortDescription,
      longDescription: longDescription,
      image: image,
      icon: icon,
      price: price.toDouble(),
      duration: duration,
      contentUrl: contentUrl,
    );
    return Response.json(body: course.toJson());
  }
  return Response(statusCode: 405);
}