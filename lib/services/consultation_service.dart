import 'package:uuid/uuid.dart';
import '../data/mysql_connection.dart';
import '../models/consultation.dart';

class ConsultationService {
  /// Retrieve all available consultations.
  static Future<List<Consultation>> getAllConsultations() async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query('SELECT * FROM consultations');
      return results.map((row) => Consultation.fromMap(row.fields)).toList();
    } finally {
      await conn.close();
    }
  }

  /// Retrieve a specific consultation by its ID.
  static Future<Consultation?> getConsultationById(String consultationId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query(
        'SELECT * FROM consultations WHERE id = ?',
        [consultationId],
      );
      if (results.isEmpty) return null;
      return Consultation.fromMap(results.first.fields);
    } finally {
      await conn.close();
    }
  }

  /// Create a new consultation record.
  static Future<Consultation> createConsultation({
    required String title,
    required String shortDescription,
    required double price,
  }) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final consultationId = Uuid().v4();
      await conn.query(
        'INSERT INTO consultations (id, title, short_description, price, created_at, updated_at) VALUES (?, ?, ?, ?, NOW(), NOW())',
        [consultationId, title, shortDescription, price],
      );
      return Consultation(
        id: consultationId,
        title: title,
        shortDescription: shortDescription,
        price: price,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy: null,
        updatedBy: null,
      );
    } finally {
      await conn.close();
    }
  }

  /// Update an existing consultation record.
  static Future<bool> updateConsultation(String consultationId, Map<String, dynamic> body) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final updates = <String>[];
      final params = <Object?>[];

      if (body.containsKey('title')) {
        updates.add('title = ?');
        params.add(body['title']);
      }
      if (body.containsKey('shortDescription')) {
        updates.add('short_description = ?');
        params.add(body['shortDescription']);
      }
      if (body.containsKey('price')) {
        updates.add('price = ?');
        params.add(body['price']);
      }

      if (updates.isEmpty) return false;
      updates.add('updated_at = NOW()');
      params.add(consultationId); // For WHERE clause
      final query = 'UPDATE consultations SET ${updates.join(", ")} WHERE id = ?';
      final result = await conn.query(query, params);
      return result.affectedRows != null && result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  /// Delete a consultation record.
  static Future<bool> deleteConsultation(String consultationId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final result = await conn.query(
        'DELETE FROM consultations WHERE id = ?',
        [consultationId],
      );
      return result.affectedRows != null && result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  /// Retrieve consultations purchased by a user (join with orders where service_type = 'consultation' and status = 'paid').
  static Future<List<Consultation>> getPurchasedConsultations(String userId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query(
        "SELECT c.* FROM consultations c JOIN orders o ON c.id = o.service_id WHERE o.user_id = ? AND o.service_type = 'consultation' AND o.status = 'paid'",
        [userId],
      );
      return results.map((row) => Consultation.fromMap(row.fields)).toList();
    } finally {
      await conn.close();
    }
  }
}