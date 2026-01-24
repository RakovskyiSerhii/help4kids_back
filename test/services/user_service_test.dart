import 'package:test/test.dart';
import 'package:help4kids/services/user_service.dart';
import 'package:help4kids/models/user.dart';
import 'package:help4kids/data/mysql_connection.dart';
import '../fake_connection_enhanced.dart' as fake_conn;

void main() {
  group('UserService', () {
    setUp(() {
      // Create enhanced fake connection with test data
      final testData = <String, List<Map<String, dynamic>>>{
        'users': [
          {
            'id': 'user-123',
            'email': 'test@example.com',
            'password_hash': 'hashed-password',
            'first_name': 'Test',
            'last_name': 'User',
            'role_id': 'role-customer',
            'is_verified': true,
            'phone': '+380501234567',
            'created_at': DateTime.now(),
            'updated_at': DateTime.now(),
            'created_by': null,
            'updated_by': null,
          },
        ],
      };

      MySQLConnection.connectionFactory = () async =>
          fake_conn.EnhancedFakeMySqlConnection(data: testData);
    });

    test('getUserById returns user with phone field', () async {
      final user = await UserService.getUserById('user-123');
      expect(user, isNotNull);
      expect(user?.id, equals('user-123'));
      expect(user?.email, equals('test@example.com'));
      expect(user?.phone, equals('+380501234567'));
    });

    test('updateUser updates phone number', () async {
      final updateData = {'phone': '+380509876543'};
      final success = await UserService.updateUser('user-123', updateData);
      expect(success, isTrue);
    });

    test('updateUser updates firstName', () async {
      final updateData = {'firstName': 'Updated'};
      final success = await UserService.updateUser('user-123', updateData);
      expect(success, isTrue);
    });

    test('updateUser updates lastName', () async {
      final updateData = {'lastName': 'Name'};
      final success = await UserService.updateUser('user-123', updateData);
      expect(success, isTrue);
    });

    test('updateUser updates multiple fields', () async {
      final updateData = {
        'firstName': 'New',
        'lastName': 'Name',
        'phone': '+380501111111',
      };
      final success = await UserService.updateUser('user-123', updateData);
      expect(success, isTrue);
    });

    test('updateUser returns false for empty update data', () async {
      final updateData = <String, dynamic>{};
      final success = await UserService.updateUser('user-123', updateData);
      expect(success, isFalse);
    });

    test('updateUser handles null phone', () async {
      final updateData = {'phone': null};
      final success = await UserService.updateUser('user-123', updateData);
      expect(success, isTrue);
    });
  });
}

