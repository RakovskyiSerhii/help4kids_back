import 'package:uuid/uuid.dart';
import '../data/mysql_connection.dart';
import '../models/consultation.dart';

class ConsultationService {
  /// Retrieve all available consultations.
  static Future<List<Consultation>> getAllConsultations() async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query('SELECT * FROM consultations');
      return results.map((row) {
        final fields = row.fields;
        return Consultation(
          id: fields['id']?.toString() ?? '',
          title: fields['title']?.toString() ?? '',
          shortDescription: fields['short_description']?.toString() ?? '',
          price: double.tryParse(fields['price']?.toString() ?? '0') ?? 0,
          createdAt: DateTime.parse(fields['created_at'].toString()),
          updatedAt: DateTime.parse(fields['updated_at'].toString()),
          createdBy: fields['created_by']?.toString(),
          updatedBy: fields['updated_by']?.toString(),
        );
      }).toList();
    } finally {
      await conn.close();
    }
  }

  /// Retrieve a specific consultation by its ID.
  static Future<Consultation?> getConsultationById(String consultationId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query("SELECT * FROM consultations WHERE id = '$consultationId'");
      if (results.isEmpty) return null;
      final fields = results.first.fields;
      return Consultation(
        id: fields['id']?.toString() ?? '',
        title: fields['title']?.toString() ?? '',
        shortDescription: fields['short_description']?.toString() ?? '',
        price: double.tryParse(fields['price']?.toString() ?? '0') ?? 0,
        createdAt: DateTime.parse(fields['created_at'].toString()),
        updatedAt: DateTime.parse(fields['updated_at'].toString()),
        createdBy: fields['created_by']?.toString(),
        updatedBy: fields['updated_by']?.toString(),
      );
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
      // Note: Numeric fields (price) are not wrapped in quotes.
      await conn.query(
          "INSERT INTO consultations (id, title, short_description, price, created_at, updated_at) VALUES ('$consultationId', '$title', '$shortDescription', $price, NOW(), NOW())"
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

      if (body.containsKey('title')) {
        updates.add("title = '${body['title']}'");
      }
      if (body.containsKey('shortDescription')) {
        updates.add("short_description = '${body['shortDescription']}'");
      }
      if (body.containsKey('price')) {
        updates.add("price = ${body['price']}");
      }

      if (updates.isEmpty) return false;
      final query = "UPDATE consultations SET ${updates.join(', ')}, updated_at = NOW() WHERE id = '$consultationId'";
      final result = await conn.query(query);
      return result.affectedRows != null && result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  /// Delete a consultation record.
  static Future<bool> deleteConsultation(String consultationId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final result = await conn.query("DELETE FROM consultations WHERE id = '$consultationId'");
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
          "SELECT c.* FROM consultations c JOIN orders o ON c.id = o.service_id WHERE o.user_id = '$userId' AND o.service_type = 'consultation' AND o.status = 'paid'"
      );
      return results.map((row) {
        final fields = row.fields;
        return Consultation(
          id: fields['id']?.toString() ?? '',
          title: fields['title']?.toString() ?? '',
          shortDescription: fields['short_description']?.toString() ?? '',
          price: double.tryParse(fields['price']?.toString() ?? '0') ?? 0,
          createdAt: DateTime.parse(fields['created_at'].toString()),
          updatedAt: DateTime.parse(fields['updated_at'].toString()),
          createdBy: fields['created_by']?.toString(),
          updatedBy: fields['updated_by']?.toString(),
        );
      }).toList();
    } finally {
      await conn.close();
    }
  }
}