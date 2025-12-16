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
  static Future<bool> createStaff({
    required String name,
    String? content,
    bool featured = false,
  }) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final id = Uuid().v4();
      await conn.query(
        'INSERT INTO staff (id, name, content, featured, created_at, updated_at) VALUES (?, ?, ?, ?, NOW(), NOW())',
        [id, name, content ?? '', featured ? 1 : 0],
      );
      return true;
    } finally {
      await conn.close();
    }
  }
}
