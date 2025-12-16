import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/consultation_appointment_service.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context, String appointmentId) async {
  // Apply auth middleware and require admin/god role
  final handler = requireAdmin((context) async {
    if (!Validation.isValidUuid(appointmentId)) {
      return ResponseHelpers.error(
        ApiErrors.validationError('Invalid appointment ID format'),
      );
    }

    if (context.request.method == HttpMethod.get) {
      try {
        // GET /api/consultation-appointments/{appointmentId}: Retrieve appointment details
        final appointment = await ConsultationAppointmentService.getAppointmentById(appointmentId);
        if (appointment == null) {
          return ResponseHelpers.error(ApiErrors.notFound('Appointment'));
        }
        return ResponseHelpers.success(appointment.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to fetch appointment'),
        );
      }
    } else if (context.request.method == HttpMethod.put) {
      try {
        // PUT /api/consultation-appointments/{appointmentId}: Update appointment details
        final body = await context.request.json() as Map<String, dynamic>;
        final success = await ConsultationAppointmentService.updateAppointment(appointmentId, body);
        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Update failed'),
          );
        }
        final updatedAppointment = await ConsultationAppointmentService.getAppointmentById(appointmentId);
        if (updatedAppointment == null) {
          return ResponseHelpers.error(ApiErrors.notFound('Appointment'));
        }
        return ResponseHelpers.success(updatedAppointment.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to update appointment'),
        );
      }
    } else if (context.request.method == HttpMethod.delete) {
      try {
        // DELETE /api/consultation-appointments/{appointmentId}: Delete appointment
        final success = await ConsultationAppointmentService.deleteAppointment(appointmentId);
        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Deletion failed'),
          );
        }
        return ResponseHelpers.success({'message': 'Appointment deleted successfully'});
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to delete appointment'),
        );
      }
    }

    return ResponseHelpers.methodNotAllowed();
  });

  return handler(context);
}