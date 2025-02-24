import 'package:uuid/uuid.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import '../data/mysql_connection.dart';
import '../models/user.dart';

class AuthService {
  static Future<User?> login(String email, String password) async {
    print('open');
    final conn = await MySQLConnection.openConnection();

    try {
      print('query');
      // Using interpolation for email (as per your change)
      final results = await conn.query(
        "SELECT * FROM users WHERE email like '$email'",
      );
      print('open');
      print('results.isEmpty ${results.isEmpty}');

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
        createdBy: row['created_by'].toString(),
        updatedBy: row['updated_by'].toString(),
        isVerified: bool.tryParse(row['is_verified'].toString()) ?? false,
      );
      print(user);
      if (!BCrypt.checkpw(password, user.passwordHash)) return null;
      return user;
    } finally {
      await conn.close();
    }
  }

  static String generateJwt(User user) {
    final jwt = JWT(
      {
        'id': user.id,
        'email': user.email,
        'roleId': user.roleId,
      },
      issuer: 'help4kids.com',
    );
    return jwt.sign(SecretKey('your_secret_key'),
        expiresIn: Duration(hours: 24));
  }

  // Updated registerUser using string interpolation.
  static Future<bool> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final conn = await MySQLConnection.openConnection();
    try {
      // Check if a user with the given email already exists.
      final existing = await conn.query("SELECT * FROM users WHERE email = '$email'");
      if (existing.isNotEmpty) {
        return false; // Email already registered.
      }

      // Get the customer role id.
      final roleResult = await conn.query("SELECT id FROM roles WHERE name = 'customer'");
      if (roleResult.isEmpty) {
        throw Exception("Customer role not found.");
      }
      final customerRoleId = roleResult.first.fields['id'].toString();

      // Generate a verification token internally.
      final verificationToken = Uuid().v4();
      // Hash the password.
      final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
      final userId = Uuid().v4();

      // Insert new user with is_verified = false.
      await conn.query(
        '''
        INSERT INTO users 
          (id, email, password_hash, first_name, last_name, role_id, is_verified, created_at, updated_at)
        VALUES 
          ('$userId', '$email', '$hashedPassword', '$firstName', '$lastName', '$customerRoleId', false, NOW(), NOW())
        ''',
      );

      // Delete any existing email verification records for this user (if any)
      await conn.query("DELETE FROM email_verification WHERE user_id = '$userId'");

      // Insert the new verification record into the email_verification table.
      final evId = Uuid().v4();
      await conn.query(
          "INSERT INTO email_verification (id, user_id, token, created_at) VALUES ('$evId', '$userId', '$verificationToken', NOW())"
      );

      // TODO: Trigger email sending via your backend email service.
      // await EmailService.sendVerificationEmail(email: email, token: verificationToken);

      return true;
    } finally {
      await conn.close();
    }
  }
  static Future<bool> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query(
        'SELECT password_hash FROM users WHERE id = $userId',
      );
      if (results.isEmpty) return false;
      final row = results.first;
      final currentHash = row['password_hash'] as String;
      if (!BCrypt.checkpw(currentPassword, currentHash)) return false;
      final newHash = BCrypt.hashpw(newPassword, BCrypt.gensalt());
      final result = await conn.query(
        'UPDATE users SET password_hash = $newHash, updated_at = NOW() WHERE id = $userId',
      );
      return result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  static Future<bool> resendVerificationEmail({required String email}) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query("SELECT * FROM users WHERE email = '$email'");
      if (results.isEmpty) {
        return false;
      }
      final userRow = results.first;
      if (userRow['is_verified'] == true || userRow['is_verified'] == 1) {
        return false;
      }
      final userId = userRow['id'].toString();
      final newToken = Uuid().v4();
      // Remove any existing token record for this user.
      await conn.query("DELETE FROM email_verification WHERE user_id = '$userId'");
      // Insert new token.
      final evId = Uuid().v4();
      await conn.query(
          "INSERT INTO email_verification (id, user_id, token, created_at) VALUES ('$evId', '$userId', '$newToken', NOW())"
      );
      //todo Send verification email.
      // await EmailService.sendVerificationEmail(email: email, token: newToken);
      return true;
    } catch (e) {
      return false;
    } finally {
      await conn.close();
    }
  }

  static Future<bool> verifyEmail(String token) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query("SELECT * FROM email_verification WHERE token = '$token'");
      if (results.isEmpty) return false;
      final userId = results.first.fields['user_id'].toString();
      await conn.query("UPDATE users SET is_verified = true, updated_at = NOW() WHERE id = '$userId'");
      await conn.query("DELETE FROM email_verification WHERE token = '$token'");
      return true;
    } finally {
      await conn.close();
    }
  }

  // Updated getUserProfile using string interpolation.
  static Future<User?> getUserProfile(String userId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results =
          await conn.query("SELECT * FROM users WHERE id = '$userId'");
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
        createdBy: row['created_by'].toString(),
        updatedBy: row['updated_by'].toString(),
        isVerified: bool.tryParse(row['is_verified'].toString()) ?? false,
      );
    } finally {
      await conn.close();
    }
  }
}
