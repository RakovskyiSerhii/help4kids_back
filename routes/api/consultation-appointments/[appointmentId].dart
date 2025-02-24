import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/consultation_appointment_service.dart';

Future<Response> onRequest(RequestContext context, String appointmentId) async {
  // Check authorization: Only 'admin' or 'god' allowed.
  final role = context.request.headers['x-role'] ?? 'customer';
  if (role != 'admin' && role != 'god') {
    return Response.json(
      body: {'error': 'Unauthorized'},
      statusCode: 403,
    );
  }

  if (context.request.method == HttpMethod.get) {
    // GET /api/consultation-appointments/{appointmentId}: Retrieve appointment details
    final appointment = await ConsultationAppointmentService.getAppointmentById(appointmentId);
    if (appointment == null) {
      return Response.json(
        body: {'error': 'Appointment not found'},
        statusCode: 404,
      );
    }
    return Response.json(body: appointment.toJson());
  } else if (context.request.method == HttpMethod.put) {
    // PUT /api/consultation-appointments/{appointmentId}: Update appointment details
    final body = await context.request.json();
    final success = await ConsultationAppointmentService.updateAppointment(appointmentId, body);
    if (!success) {
      return Response.json(
        body: {'error': 'Update failed'},
        statusCode: 400,
      );
    }
    final updatedAppointment = await ConsultationAppointmentService.getAppointmentById(appointmentId);
    return Response.json(body: updatedAppointment?.toJson() ?? {});
  } else if (context.request.method == HttpMethod.delete) {
    // DELETE /api/consultation-appointments/{appointmentId}: Delete appointment
    final success = await ConsultationAppointmentService.deleteAppointment(appointmentId);
    if (!success) {
      return Response.json(
        body: {'error': 'Deletion failed'},
        statusCode: 400,
      );
    }
    return Response.json(body: {'message': 'Appointment deleted successfully'});
  }

  return Response(statusCode: 405);
}