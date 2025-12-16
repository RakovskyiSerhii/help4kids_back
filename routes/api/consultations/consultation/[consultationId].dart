import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/consultation_service.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context, String consultationId) async {
  // GET /api/consultations/{consultationId}: Get consultation details
  if (context.request.method == HttpMethod.get) {
    try {
      if (!Validation.isValidUuid(consultationId)) {
        return ResponseHelpers.error(
          ApiErrors.validationError('Invalid consultation ID format'),
        );
      }
      final consultation = await ConsultationService.getConsultationById(consultationId);
      if (consultation == null) {
        return ResponseHelpers.error(ApiErrors.notFound('Consultation'));
      }
      return ResponseHelpers.success(consultation.toJson());
    } catch (e) {
      return ResponseHelpers.error(
        ApiErrors.internalError('Failed to fetch consultation'),
      );
    }
  }
  // PUT /api/consultations/{consultationId}: Update consultation details (admin/god only)
  else if (context.request.method == HttpMethod.put) {
    final handler = requireAdmin((context) async {
      try {
        if (!Validation.isValidUuid(consultationId)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Invalid consultation ID format'),
          );
        }
        final body = await context.request.json() as Map<String, dynamic>;
        final success = await ConsultationService.updateConsultation(consultationId, body);
        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Update failed'),
          );
        }
        final updatedConsultation = await ConsultationService.getConsultationById(consultationId);
        if (updatedConsultation == null) {
          return ResponseHelpers.error(ApiErrors.notFound('Consultation'));
        }
        return ResponseHelpers.success(updatedConsultation.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to update consultation'),
        );
      }
    });
    return handler(context);
  }
  // DELETE /api/consultations/{consultationId}: Delete consultation (admin/god only)
  else if (context.request.method == HttpMethod.delete) {
    final handler = requireAdmin((context) async {
      try {
        if (!Validation.isValidUuid(consultationId)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Invalid consultation ID format'),
          );
        }
        final success = await ConsultationService.deleteConsultation(consultationId);
        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Deletion failed'),
          );
        }
        return ResponseHelpers.success({'message': 'Consultation deleted successfully'});
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to delete consultation'),
        );
      }
    });
    return handler(context);
  }
  return ResponseHelpers.methodNotAllowed();
}