import '../data/mysql_connection.dart';
import '../models/user.dart';

class UserService {
  // Retrieve all users
  static Future<List<User>> getAllUsers() async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query('SELECT * FROM users');
      return results.map((row) {
        final fields = row.fields;
        return User(
          id: fields['id']?.toString() ?? '',
          email: fields['email']?.toString() ?? '',
          passwordHash: fields['password_hash']?.toString() ?? '',
          firstName: fields['first_name']?.toString() ?? '',
          lastName: fields['last_name']?.toString() ?? '',
          roleId: fields['role_id']?.toString() ?? '',
          createdAt: DateTime.parse(fields['created_at'].toString()),
          updatedAt: DateTime.parse(fields['updated_at'].toString()),
          createdBy: fields['created_by']?.toString(),
          updatedBy: fields['updated_by']?.toString(),
          isVerified: _parseBool(fields['is_verified']),
        );
      }).toList();
    } finally {
      await conn.close();
    }
  }

  // Retrieve a specific user by ID
  static Future<User?> getUserById(String userId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query(
        'SELECT * FROM users WHERE id = ?',
        [userId],
      );
      if (results.isEmpty) return null;
      final fields = results.first.fields;
      return User(
        id: fields['id']?.toString() ?? '',
        email: fields['email']?.toString() ?? '',
        passwordHash: fields['password_hash']?.toString() ?? '',
        firstName: fields['first_name']?.toString() ?? '',
        lastName: fields['last_name']?.toString() ?? '',
        roleId: fields['role_id']?.toString() ?? '',
        createdAt: DateTime.parse(fields['created_at'].toString()),
        updatedAt: DateTime.parse(fields['updated_at'].toString()),
        createdBy: fields['created_by']?.toString(),
        updatedBy: fields['updated_by']?.toString(),
        isVerified: _parseBool(fields['is_verified']),
      );
    } finally {
      await conn.close();
    }
  }

  // Helper to parse boolean from various types
  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }

  // Update a user with dynamic fields
  static Future<bool> updateUser(
      String userId, Map<String, dynamic> body) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final updates = <String>[];
      final params = <Object?>[];

      if (body.containsKey('email')) {
        updates.add('email = ?');
        params.add(body['email']);
      }
      if (body.containsKey('firstName')) {
        updates.add('first_name = ?');
        params.add(body['firstName']);
      }
      if (body.containsKey('lastName')) {
        updates.add('last_name = ?');
        params.add(body['lastName']);
      }
      if (body.containsKey('roleId')) {
        updates.add('role_id = ?');
        params.add(body['roleId']);
      }

      if (updates.isEmpty) return false;

      updates.add('updated_at = NOW()');
      params.add(userId); // For WHERE clause

      final query = 'UPDATE users SET ${updates.join(", ")} WHERE id = ?';
      final result = await conn.query(query, params);
      return result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  // Delete a user
  static Future<bool> deleteUser(String userId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final result = await conn.query(
        'DELETE FROM users WHERE id = ?',
        [userId],
      );
      return result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }
}
