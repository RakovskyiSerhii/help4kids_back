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
      final results = await conn.query(
        'SELECT * FROM consultation_appointments WHERE id = ?',
        [appointmentId],
      );
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
      await conn.query(
        'INSERT INTO consultation_appointments (id, consultation_id, appointment_datetime, details, order_id) VALUES (?, ?, ?, ?, ?)',
        [newAppointmentId, consultationId, dateStr, details, orderId],
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
      final params = <Object?>[];

      if (body.containsKey('consultationId')) {
        updates.add('consultation_id = ?');
        params.add(body['consultationId']);
      }
      if (body.containsKey('appointmentDatetime')) {
        final dt = DateTime.tryParse(body['appointmentDatetime'].toString());
        if (dt != null) {
          updates.add('appointment_datetime = ?');
          params.add(dt.toIso8601String());
        }
      }
      if (body.containsKey('details')) {
        updates.add('details = ?');
        params.add(body['details']);
      }
      if (body.containsKey('orderId')) {
        updates.add('order_id = ?');
        params.add(body['orderId']);
      }
      if (updates.isEmpty) return false;
      updates.add('updated_at = NOW()');
      params.add(appointmentId); // For WHERE clause
      final query = 'UPDATE consultation_appointments SET ${updates.join(", ")} WHERE id = ?';
      final result = await conn.query(query, params);
      return result.affectedRows != null && result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  /// Deletes a consultation appointment.
  static Future<bool> deleteAppointment(String appointmentId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final result = await conn.query(
        'DELETE FROM consultation_appointments WHERE id = ?',
        [appointmentId],
      );
      return result.affectedRows != null && result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }
}