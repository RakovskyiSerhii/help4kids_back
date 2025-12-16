import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/consultation_appointment_service.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context, String appointmentId) async {
  // Apply auth middleware and require admin/god role
  final handler = requireAdmin((context) async {
    if (context.request.method != HttpMethod.post) {
      return ResponseHelpers.methodNotAllowed();
    }

    if (!Validation.isValidUuid(appointmentId)) {
      return ResponseHelpers.error(
        ApiErrors.validationError('Invalid appointment ID format'),
      );
    }

    try {
      final payload = getCurrentUser(context);
      if (payload == null) {
        return ResponseHelpers.error(ApiErrors.unauthorized());
      }

      final success = await ConsultationAppointmentService.markProcessed(
        appointmentId: appointmentId,
        processedByUserId: payload.id,
      );
      if (!success) {
        return ResponseHelpers.error(
          ApiErrors.notFound('Appointment'),
        );
      }

      return ResponseHelpers.success(
        {'message': 'Appointment marked as processed'},
      );
    } catch (e) {
      return ResponseHelpers.error(
        ApiErrors.internalError('Failed to mark appointment as processed'),
      );
    }
  });

  return handler(context);
}


