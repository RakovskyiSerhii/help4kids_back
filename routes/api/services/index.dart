import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/service_service.dart';

Future<Response> onRequest(RequestContext context) async {
  // GET /api/services: List all services (public)
  if (context.request.method == HttpMethod.get) {
    final services = await ServiceService.getAllServices();
    return Response.json(
      body: {'services': services.map((s) => s.toJson()).toList()},
    );
  }
  // POST /api/services: Create a new service (admin/god only)
  else if (context.request.method == HttpMethod.post) {
    // Check role header for authorization (simulate: only 'admin' or 'god' allowed)
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
    final icon = body['icon'] as String?;
    final price = body['price'] as num?;
    final categoryId = body['categoryId'] as String?;
    if (title == null || shortDescription == null || icon == null || price == null || categoryId == null) {
      return Response.json(
        body: {'error': 'Missing required fields'},
        statusCode: 400,
      );
    }
    // Optional fields
    final longDescription = body['longDescription'] as String?;
    final image = body['image'] as String?;
    final duration = body['duration'] as int?;

    final service = await ServiceService.createService(
      title: title,
      shortDescription: shortDescription,
      longDescription: longDescription,
      image: image,
      icon: icon,
      price: price.toDouble(),
      duration: duration,
      categoryId: categoryId,
    );
    return Response.json(body: service.toJson());
  }
  return Response(statusCode: 405);
}