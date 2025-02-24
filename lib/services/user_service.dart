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
          isVerified: bool.tryParse(fields['is_verified'].toString()) ?? false,
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
      final results =
          await conn.query("SELECT * FROM users WHERE id = '$userId'");
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
        isVerified: bool.tryParse(fields['is_verified'].toString()) ?? false,
      );
    } finally {
      await conn.close();
    }
  }

  // Update a user with dynamic fields
  static Future<bool> updateUser(
      String userId, Map<String, dynamic> body) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final fields = <String>[];

      if (body.containsKey('email')) {
        fields.add("email = '${body['email']}'");
      }
      if (body.containsKey('firstName')) {
        fields.add("first_name = '${body['firstName']}'");
      }
      if (body.containsKey('lastName')) {
        fields.add("last_name = '${body['lastName']}'");
      }
      if (body.containsKey('roleId')) {
        fields.add("role_id = '${body['roleId']}'");
      }

      if (fields.isEmpty) return false;

      final query =
          "UPDATE users SET ${fields.join(", ")}, updated_at = NOW() WHERE id = '$userId'";
      final result = await conn.query(query);
      return result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  // Delete a user
  static Future<bool> deleteUser(String userId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final result = await conn.query("DELETE FROM users WHERE id = '$userId'");
      return result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }
}
