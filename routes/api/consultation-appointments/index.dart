import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/consultation_appointment_service.dart';

Future<Response> onRequest(RequestContext context) async {
  // Check authorization: Only 'admin' or 'god' allowed.
  final role = context.request.headers['x-role'] ?? 'customer';
  if (role != 'admin' && role != 'god') {
    return Response.json(
      body: {'error': 'Unauthorized'},
      statusCode: 403,
    );
  }

  if (context.request.method == HttpMethod.get) {
    // GET /api/consultation-appointments: List all appointments
    final appointments = await ConsultationAppointmentService.getAllAppointments();
    return Response.json(
      body: {'appointments': appointments.map((a) => a.toJson()).toList()},
    );
  } else if (context.request.method == HttpMethod.post) {
    // POST /api/consultation-appointments: Create a new appointment (admin/god only)
    final body = await context.request.json();

    // Validate required fields
    final consultationId = body['consultationId'] as String?;
    final appointmentDatetimeStr = body['appointmentDatetime'] as String?;
    final orderId = body['orderId'] as String?;
    if (consultationId == null || appointmentDatetimeStr == null || orderId == null) {
      return Response.json(
        body: {'error': 'Missing required fields: consultationId, appointmentDatetime, orderId'},
        statusCode: 400,
      );
    }
    final appointmentDatetime = DateTime.tryParse(appointmentDatetimeStr);
    if (appointmentDatetime == null) {
      return Response.json(
        body: {'error': 'Invalid appointmentDatetime format'},
        statusCode: 400,
      );
    }
    final appointment = await ConsultationAppointmentService.createAppointment(
      consultationId: consultationId,
      appointmentDatetime: appointmentDatetime,
      orderId: orderId,
      details: body['details'] as String?,
    );
    return Response.json(body: appointment.toJson());
  }

  return Response(statusCode: 405);
}