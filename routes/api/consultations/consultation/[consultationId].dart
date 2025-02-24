import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/consultation_service.dart';

Future<Response> onRequest(RequestContext context, String consultationId) async {
  // GET /api/consultations/{consultationId}: Get consultation details
  if (context.request.method == HttpMethod.get) {
    final consultation = await ConsultationService.getConsultationById(consultationId);
    if (consultation == null) {
      return Response.json(
        body: {'error': 'Consultation not found'},
        statusCode: 404,
      );
    }
    return Response.json(body: consultation.toJson());
  }
  // PUT /api/consultations/{consultationId}: Update consultation details (admin/god only)
  else if (context.request.method == HttpMethod.put) {
    final role = context.request.headers['x-role'] ?? 'customer';
    if (role != 'admin' && role != 'god') {
      return Response.json(
        body: {'error': 'Unauthorized'},
        statusCode: 403,
      );
    }
    final body = await context.request.json();
    final success = await ConsultationService.updateConsultation(consultationId, body);
    if (!success) {
      return Response.json(
        body: {'error': 'Update failed'},
        statusCode: 400,
      );
    }
    final updatedConsultation = await ConsultationService.getConsultationById(consultationId);
    return Response.json(body: updatedConsultation?.toJson() ?? {});
  }
  // DELETE /api/consultations/{consultationId}: Delete consultation (admin/god only)
  else if (context.request.method == HttpMethod.delete) {
    final role = context.request.headers['x-role'] ?? 'customer';
    if (role != 'admin' && role != 'god') {
      return Response.json(
        body: {'error': 'Unauthorized'},
        statusCode: 403,
      );
    }
    final success = await ConsultationService.deleteConsultation(consultationId);
    if (!success) {
      return Response.json(
        body: {'error': 'Deletion failed'},
        statusCode: 400,
      );
    }
    return Response.json(body: {'message': 'Consultation deleted successfully'});
  }
  return Response(statusCode: 405);
}