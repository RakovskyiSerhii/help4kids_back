import 'package:uuid/uuid.dart';
import '../data/mysql_connection.dart';
import '../models/staff.dart';

class StaffService {
  // Retrieve all staff members
  static Future<List<Staff>> getAllStaff() async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query('SELECT * FROM staff');
      return results.map((row) {
        final fields = row.fields;
        return Staff(
          id: fields['id']?.toString() ?? '',
          name: fields['name']?.toString() ?? '',
          content: fields['content']?.toString(),
          photoUrl: fields['photo_url']?.toString(),
          featured: (fields['featured'] is int)
              ? (fields['featured'] as int) == 1
              : (fields['featured'] as bool? ?? false),
          createdAt: DateTime.parse(fields['created_at'].toString()),
          updatedAt: DateTime.parse(fields['updated_at'].toString()),
        );
      }).toList();
    } finally {
      await conn.close();
    }
  }

  // Retrieve a specific staff member by ID
  static Future<Staff?> getStaffById(String id) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query(
        'SELECT * FROM staff WHERE id = ?',
        [id],
      );
      if (results.isEmpty) return null;
      final fields = results.first.fields;
      return Staff(
        id: fields['id']?.toString() ?? '',
        name: fields['name']?.toString() ?? '',
        content: fields['content']?.toString(),
        photoUrl: fields['photo_url']?.toString(),
        featured: (fields['featured'] is int)
            ? (fields['featured'] as int) == 1
            : (fields['featured'] as bool? ?? false),
        createdAt: DateTime.parse(fields['created_at'].toString()),
        updatedAt: DateTime.parse(fields['updated_at'].toString()),
      );
    } finally {
      await conn.close();
    }
  }

  // Create a new staff member
  static Future<Staff> createStaff({
    required String name,
    String? content,
    String? photoUrl,
    bool featured = false,
  }) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final id = Uuid().v4();
      await conn.query(
        'INSERT INTO staff (id, name, content, photo_url, featured, created_at, updated_at) VALUES (?, ?, ?, ?, ?, NOW(), NOW())',
        [id, name, content, photoUrl, featured ? 1 : 0],
      );
      return Staff(
        id: id,
        name: name,
        content: content,
        photoUrl: photoUrl,
        featured: featured,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } finally {
      await conn.close();
    }
  }

  // Update a staff member
  static Future<bool> updateStaff(String staffId, Map<String, dynamic> updates) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final updateFields = <String>[];
      final params = <Object?>[];

      if (updates.containsKey('name')) {
        updateFields.add('name = ?');
        params.add(updates['name']);
      }
      if (updates.containsKey('content')) {
        updateFields.add('content = ?');
        params.add(updates['content']);
      }
      if (updates.containsKey('photoUrl')) {
        updateFields.add('photo_url = ?');
        params.add(updates['photoUrl']);
      }
      if (updates.containsKey('featured')) {
        updateFields.add('featured = ?');
        params.add((updates['featured'] as bool) ? 1 : 0);
      }
      if (updates.containsKey('ordering')) {
        updateFields.add('ordering = ?');
        params.add(updates['ordering']);
      }

      if (updateFields.isEmpty) return false;

      updateFields.add('updated_at = NOW()');
      params.add(staffId);

      final query = 'UPDATE staff SET ${updateFields.join(", ")} WHERE id = ?';
      final result = await conn.query(query, params);
      return result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  // Delete a staff member
  static Future<bool> deleteStaff(String staffId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final result = await conn.query(
        'DELETE FROM staff WHERE id = ?',
        [staffId],
      );
      return result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }
}
