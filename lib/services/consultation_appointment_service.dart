import 'package:uuid/uuid.dart';
import '../data/mysql_connection.dart';
import '../models/consultation_appointment.dart';

class ConsultationAppointmentService {
  /// Retrieves all consultation appointments.
  static Future<List<ConsultationAppointment>> getAllAppointments() async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query('SELECT * FROM consultation_appointments');
      return results.map((row) {
        final fields = row.fields;
        return ConsultationAppointment(
          id: fields['id']?.toString() ?? '',
          consultationId: fields['consultation_id']?.toString() ?? '',
          appointmentDatetime: DateTime.parse(fields['appointment_datetime'].toString()),
          details: fields['details']?.toString(),
          orderId: fields['order_id']?.toString() ?? '',
        );
      }).toList();
    } finally {
      await conn.close();
    }
  }

  /// Retrieves a specific consultation appointment by its ID.
  static Future<ConsultationAppointment?> getAppointmentById(String appointmentId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query("SELECT * FROM consultation_appointments WHERE id = '$appointmentId'");
      if (results.isEmpty) return null;
      final fields = results.first.fields;
      return ConsultationAppointment(
        id: fields['id']?.toString() ?? '',
        consultationId: fields['consultation_id']?.toString() ?? '',
        appointmentDatetime: DateTime.parse(fields['appointment_datetime'].toString()),
        details: fields['details']?.toString(),
        orderId: fields['order_id']?.toString() ?? '',
      );
    } finally {
      await conn.close();
    }
  }

  /// Creates a new consultation appointment.
  static Future<ConsultationAppointment> createAppointment({
    required String consultationId,
    required DateTime appointmentDatetime,
    required String orderId,
    String? details,
  }) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final newAppointmentId = Uuid().v4();
      final dateStr = appointmentDatetime.toIso8601String();
      // If details is null, insert SQL NULL without quotes.
      final detailsValue = details == null ? "NULL" : "'$details'";
      await conn.query(
          "INSERT INTO consultation_appointments (id, consultation_id, appointment_datetime, details, order_id) "
              "VALUES ('$newAppointmentId', '$consultationId', '$dateStr', $detailsValue, '$orderId')"
      );
      return ConsultationAppointment(
        id: newAppointmentId,
        consultationId: consultationId,
        appointmentDatetime: appointmentDatetime,
        details: details,
        orderId: orderId,
      );
    } finally {
      await conn.close();
    }
  }

  /// Updates an existing consultation appointment.
  static Future<bool> updateAppointment(String appointmentId, Map<String, dynamic> body) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final updates = <String>[];

      if (body.containsKey('consultationId')) {
        updates.add("consultation_id = '${body['consultationId']}'");
      }
      if (body.containsKey('appointmentDatetime')) {
        final dt = DateTime.tryParse(body['appointmentDatetime'].toString());
        if (dt != null) {
          updates.add("appointment_datetime = '${dt.toIso8601String()}'");
        }
      }
      if (body.containsKey('details')) {
        final d = body['details'];
        // If null, use SQL NULL; otherwise wrap in quotes.
        final detailsStr = d == null ? "NULL" : "'$d'";
        updates.add("details = $detailsStr");
      }
      if (body.containsKey('orderId')) {
        updates.add("order_id = '${body['orderId']}'");
      }
      if (updates.isEmpty) return false;
      final query = "UPDATE consultation_appointments SET ${updates.join(', ')}, updated_at = NOW() WHERE id = '$appointmentId'";
      final result = await conn.query(query);
      return result.affectedRows != null && result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  /// Deletes a consultation appointment.
  static Future<bool> deleteAppointment(String appointmentId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final result = await conn.query("DELETE FROM consultation_appointments WHERE id = '$appointmentId'");
      return result.affectedRows != null && result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }
}