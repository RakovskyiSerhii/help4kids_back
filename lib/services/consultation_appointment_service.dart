import 'package:uuid/uuid.dart';
import '../data/mysql_connection.dart';
import '../models/consultation_appointment.dart';

class ConsultationAppointmentService {
  /// Retrieves consultation appointments for the admin/god dashboard.
  ///
  /// Optional filters:
  /// - userId: filter by client user (orders.user_id)
  /// - doctorId: filter by assigned doctor (consultation_appointments.doctor_id)
  /// - from/to: ISO 8601 range applied to both appointment_datetime and created_at
  /// - processed: 'true' or 'false'
  static Future<List<Map<String, dynamic>>> getAllAppointments({
    String? userId,
    String? doctorId,
    DateTime? from,
    DateTime? to,
    bool? processed,
  }) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final conditions = <String>[];
      final params = <Object?>[];

      if (userId != null) {
        conditions.add('o.user_id = ?');
        params.add(userId);
      }
      if (doctorId != null) {
        conditions.add('ca.doctor_id = ?');
        params.add(doctorId);
      }
      if (from != null) {
        conditions.add('ca.appointment_datetime >= ?');
        conditions.add('ca.created_at >= ?');
        final fromStr = from.toIso8601String();
        params.add(fromStr);
        params.add(fromStr);
      }
      if (to != null) {
        conditions.add('ca.appointment_datetime <= ?');
        conditions.add('ca.created_at <= ?');
        final toStr = to.toIso8601String();
        params.add(toStr);
        params.add(toStr);
      }
      if (processed != null) {
        conditions.add('ca.processed = ?');
        params.add(processed ? 1 : 0);
      }

      final whereClause =
          conditions.isEmpty ? '' : 'WHERE ${conditions.join(' AND ')}';

      final query = '''
SELECT
  ca.id,
  ca.consultation_id,
  ca.appointment_datetime,
  ca.details,
  ca.order_id,
  ca.processed,
  ca.processed_by,
  ca.processed_at,
  ca.doctor_id,
  ca.created_at,
  ca.updated_at,
  o.user_id,
  u.name AS user_name,
  u.email AS user_email,
  s.name AS doctor_name,
  c.title AS consultation_title
FROM consultation_appointments ca
JOIN orders o ON ca.order_id = o.id
JOIN users u ON o.user_id = u.id
LEFT JOIN staff s ON ca.doctor_id = s.id
LEFT JOIN consultations c ON ca.consultation_id = c.id
$whereClause
ORDER BY ca.appointment_datetime DESC, ca.created_at DESC
''';

      final results = await conn.query(query, params);

      return results.map((row) {
        final f = row.fields;
        return <String, dynamic>{
          'id': f['id']?.toString(),
          'consultationId': f['consultation_id']?.toString(),
          'appointmentDatetime': f['appointment_datetime']?.toString(),
          'details': f['details'],
          'orderId': f['order_id']?.toString(),
          'processed': (f['processed'] is bool)
              ? f['processed'] as bool
              : (f['processed'] == 1),
          'processedBy': f['processed_by']?.toString(),
          'processedAt': f['processed_at']?.toString(),
          'doctorId': f['doctor_id']?.toString(),
          'createdAt': f['created_at']?.toString(),
          'updatedAt': f['updated_at']?.toString(),
          'userId': f['user_id']?.toString(),
          'userName': f['user_name']?.toString(),
          'userEmail': f['user_email']?.toString(),
          'doctorName': f['doctor_name']?.toString(),
          'consultationTitle': f['consultation_title']?.toString(),
        };
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
      if (body.containsKey('doctorId')) {
        updates.add('doctor_id = ?');
        params.add(body['doctorId']);
      }
      if (body.containsKey('processed')) {
        updates.add('processed = ?');
        final value = body['processed'];
        final boolValue = value is bool
            ? value
            : (value.toString() == 'true' || value.toString() == '1');
        params.add(boolValue ? 1 : 0);
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

  /// Marks an appointment as processed by a specific admin/god user.
  static Future<bool> markProcessed({
    required String appointmentId,
    required String processedByUserId,
  }) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final result = await conn.query(
        'UPDATE consultation_appointments SET processed = 1, processed_by = ?, processed_at = NOW(), updated_at = NOW() WHERE id = ?',
        [processedByUserId, appointmentId],
      );
      return result.affectedRows != null && result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }
}