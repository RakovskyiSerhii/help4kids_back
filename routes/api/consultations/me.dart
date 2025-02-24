import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/consultation_service.dart';

Future<Response> onRequest(RequestContext context) async {
  // In production, retrieve the authenticated user's ID via middleware
  final userId = context.request.headers['x-user-id'] ?? 'simulated-user-id';
  final consultations = await ConsultationService.getPurchasedConsultations(userId);
  return Response.json(
    body: {'consultations': consultations.map((c) => c.toJson()).toList()},
  );
}