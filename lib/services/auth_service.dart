import 'package:uuid/uuid.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import '../models/user.dart';
import '../config/app_config.dart';
import '../utils/db_helper.dart';

class AuthService {
  static Future<User?> login(String email, String password) async {
    return await DbHelper.withConnection((conn) async {
      // Use parameterized query to prevent SQL injection
      // Select only needed columns for better performance
      final results = await conn.query(
        'SELECT id, email, password_hash, first_name, last_name, role_id, is_verified, created_at, updated_at, created_by, updated_by FROM users WHERE email = ?',
        [email],
      );

      if (results.isEmpty) return null;
      final row = results.first;
      final user = User(
        id: row['id'].toString(),
        email: row['email'].toString(),
        passwordHash: row['password_hash'].toString(),
        firstName: row['first_name'].toString(),
        lastName: row['last_name'].toString(),
        roleId: row['role_id'].toString(),
        createdAt: DateTime.parse(row['created_at'].toString()),
        updatedAt: DateTime.parse(row['updated_at'].toString()),
        createdBy: row['created_by']?.toString(),
        updatedBy: row['updated_by']?.toString(),
        isVerified: _parseBool(row['is_verified']),
      );
      
      if (!BCrypt.checkpw(password, user.passwordHash)) return null;
      return user;
    });
  }

  static String generateJwt(User user) {
    final jwt = JWT(
      {
        'id': user.id,
        'email': user.email,
        'roleId': user.roleId,
      },
      issuer: AppConfig.jwtIssuer,
    );
    return jwt.sign(
      SecretKey(AppConfig.jwtSecret),
      expiresIn: Duration(hours: AppConfig.jwtExpirationHours),
    );
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

  static Future<bool> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    return await DbHelper.withConnection((conn) async {
      // Check if a user with the given email already exists using parameterized query
      // Only select id for existence check (more efficient)
      final existing = await conn.query(
        'SELECT id FROM users WHERE email = ?',
        [email],
      );
      if (existing.isNotEmpty) {
        return false; // Email already registered.
      }

      // Get the customer role id using parameterized query
      final roleResult = await conn.query(
        'SELECT id FROM roles WHERE name = ?',
        ['customer'],
      );
      if (roleResult.isEmpty) {
        throw Exception("Customer role not found.");
      }
      final customerRoleId = roleResult.first.fields['id'].toString();

      // Generate a verification token internally.
      final verificationToken = Uuid().v4();
      // Hash the password.
      final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
      final userId = Uuid().v4();

      // Insert new user with is_verified = false using parameterized query
      await conn.query(
        '''
        INSERT INTO users 
          (id, email, password_hash, first_name, last_name, role_id, is_verified, created_at, updated_at)
        VALUES 
          (?, ?, ?, ?, ?, ?, false, NOW(), NOW())
        ''',
        [userId, email, hashedPassword, firstName, lastName, customerRoleId],
      );

      // Delete any existing email verification records for this user using parameterized query
      await conn.query(
        'DELETE FROM email_verification WHERE user_id = ?',
        [userId],
      );

      // Insert the new verification record using parameterized query
      final evId = Uuid().v4();
      await conn.query(
        'INSERT INTO email_verification (id, user_id, token, created_at) VALUES (?, ?, ?, NOW())',
        [evId, userId, verificationToken],
      );

      // TODO: Trigger email sending via your backend email service.
      // await EmailService.sendVerificationEmail(email: email, token: verificationToken);

      return true;
    });
  }

  static Future<bool> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    return await DbHelper.withConnection((conn) async {
      // Use parameterized query - only select password_hash
      final results = await conn.query(
        'SELECT password_hash FROM users WHERE id = ?',
        [userId],
      );
      if (results.isEmpty) return false;
      final row = results.first;
      final currentHash = row['password_hash'] as String;
      if (!BCrypt.checkpw(currentPassword, currentHash)) return false;
      final newHash = BCrypt.hashpw(newPassword, BCrypt.gensalt());
      // Use parameterized query
      final result = await conn.query(
        'UPDATE users SET password_hash = ?, updated_at = NOW() WHERE id = ?',
        [newHash, userId],
      );
      return result.affectedRows! > 0;
    });
  }

  static Future<bool> resendVerificationEmail({required String email}) async {
    return await DbHelper.withConnection((conn) async {
      try {
        // Use parameterized query - only select needed columns
        final results = await conn.query(
          'SELECT id, is_verified FROM users WHERE email = ?',
          [email],
        );
        if (results.isEmpty) {
          return false;
        }
        final userRow = results.first;
        if (_parseBool(userRow['is_verified'])) {
          return false;
        }
        final userId = userRow['id'].toString();
        final newToken = Uuid().v4();
        // Remove any existing token record for this user using parameterized query
        await conn.query(
          'DELETE FROM email_verification WHERE user_id = ?',
          [userId],
        );
        // Insert new token using parameterized query
        final evId = Uuid().v4();
        await conn.query(
          'INSERT INTO email_verification (id, user_id, token, created_at) VALUES (?, ?, ?, NOW())',
          [evId, userId, newToken],
        );
        //todo Send verification email.
        // await EmailService.sendVerificationEmail(email: email, token: newToken);
        return true;
      } catch (e) {
        return false;
      }
    });
  }

  static Future<bool> verifyEmail(String token) async {
    return await DbHelper.withConnection((conn) async {
      // Use parameterized query - only select user_id
      final results = await conn.query(
        'SELECT user_id FROM email_verification WHERE token = ?',
        [token],
      );
      if (results.isEmpty) return false;
      final userId = results.first.fields['user_id'].toString();
      // Use parameterized query
      await conn.query(
        'UPDATE users SET is_verified = true, updated_at = NOW() WHERE id = ?',
        [userId],
      );
      // Use parameterized query
      await conn.query(
        'DELETE FROM email_verification WHERE token = ?',
        [token],
      );
      return true;
    });
  }

  static Future<User?> getUserProfile(String userId) async {
    return await DbHelper.withConnection((conn) async {
      // Use parameterized query - select only needed columns
      final results = await conn.query(
        'SELECT id, email, password_hash, first_name, last_name, role_id, is_verified, created_at, updated_at, created_by, updated_by FROM users WHERE id = ?',
        [userId],
      );
      if (results.isEmpty) return null;
      final row = results.first;
      return User(
        id: row['id'].toString(),
        email: row['email'].toString(),
        passwordHash: row['password_hash'].toString(),
        firstName: row['first_name'].toString(),
        lastName: row['last_name'].toString(),
        roleId: row['role_id'].toString(),
        createdAt: DateTime.parse(row['created_at'].toString()),
        updatedAt: DateTime.parse(row['updated_at'].toString()),
        createdBy: row['created_by']?.toString(),
        updatedBy: row['updated_by']?.toString(),
        isVerified: _parseBool(row['is_verified']),
      );
    });
  }
}
