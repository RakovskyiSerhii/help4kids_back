import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/consultation_appointment_service.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context) async {
  // Apply auth middleware and require admin/god role
  final handler = requireAdmin((context) async {
    if (context.request.method == HttpMethod.get) {
      try {
        // GET /api/consultation-appointments: List appointments for dashboard with optional filters
        final query = context.request.uri.queryParameters;

        final userId = query['userId'];
        final doctorId = query['doctorId'];
        final fromStr = query['from'];
        final toStr = query['to'];
        final processedStr = query['processed'];

        DateTime? from;
        DateTime? to;
        bool? processed;

        if (fromStr != null && fromStr.isNotEmpty) {
          from = DateTime.tryParse(fromStr);
          if (from == null) {
            return ResponseHelpers.error(
              ApiErrors.validationError('Invalid "from" date format. Use ISO 8601.'),
            );
          }
        }

        if (toStr != null && toStr.isNotEmpty) {
          to = DateTime.tryParse(toStr);
          if (to == null) {
            return ResponseHelpers.error(
              ApiErrors.validationError('Invalid "to" date format. Use ISO 8601.'),
            );
          }
        }

        if (processedStr != null && processedStr.isNotEmpty) {
          if (processedStr == 'true' || processedStr == '1') {
            processed = true;
          } else if (processedStr == 'false' || processedStr == '0') {
            processed = false;
          } else {
            return ResponseHelpers.error(
              ApiErrors.validationError('Invalid "processed" value. Use true/false or 1/0.'),
            );
          }
        }

        final appointments = await ConsultationAppointmentService.getAllAppointments(
          userId: userId,
          doctorId: doctorId,
          from: from,
          to: to,
          processed: processed,
        );
        return ResponseHelpers.success(
          {'appointments': appointments},
        );
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to fetch appointments'),
        );
      }
    } else if (context.request.method == HttpMethod.post) {
      try {
        // POST /api/consultation-appointments: Create a new appointment
        final body = await context.request.json() as Map<String, dynamic>;

        final consultationId = body['consultationId'] as String?;
        final appointmentDatetimeStr = body['appointmentDatetime'] as String?;
        final orderId = body['orderId'] as String?;

        if (consultationId == null || appointmentDatetimeStr == null || orderId == null) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Missing required fields: consultationId, appointmentDatetime, orderId'),
          );
        }

        if (!Validation.isValidUuid(consultationId)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Invalid consultation ID format'),
          );
        }

        if (!Validation.isValidUuid(orderId)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Invalid order ID format'),
          );
        }

        final appointmentDatetime = DateTime.tryParse(appointmentDatetimeStr);
        if (appointmentDatetime == null) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Invalid appointmentDatetime format. Use ISO 8601 format.'),
          );
        }

        if (appointmentDatetime.isBefore(DateTime.now())) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Appointment datetime cannot be in the past'),
          );
        }

        final appointment = await ConsultationAppointmentService.createAppointment(
          consultationId: consultationId,
          appointmentDatetime: appointmentDatetime,
          orderId: orderId,
          details: (body['details'] as String?)?.trim(),
        );
        return ResponseHelpers.success(appointment.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to create appointment'),
        );
      }
    }

    return ResponseHelpers.methodNotAllowed();
  });

  return handler(context);
}