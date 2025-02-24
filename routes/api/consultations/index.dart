import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/consultation_service.dart';

Future<Response> onRequest(RequestContext context) async {
  // GET /api/consultations: List all available consultations
  if (context.request.method == HttpMethod.get) {
    final consultations = await ConsultationService.getAllConsultations();
    return Response.json(
      body: {'consultations': consultations.map((c) => c.toJson()).toList()},
    );
  }
  // POST /api/consultations: Create a new consultation (admin/god only)
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
    final title = body['title'] as String?;
    final shortDescription = body['shortDescription'] as String?;
    final price = body['price'] as num?;
    if (title == null || shortDescription == null || price == null) {
      return Response.json(
        body: {'error': 'Missing required fields'},
        statusCode: 400,
      );
    }
    final consultation = await ConsultationService.createConsultation(
      title: title,
      shortDescription: shortDescription,
      price: price.toDouble(),
    );
    return Response.json(body: consultation.toJson());
  }
  return Response(statusCode: 405);
}