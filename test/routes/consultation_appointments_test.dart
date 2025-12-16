import 'dart:convert';
import 'package:test/test.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/data/mysql_connection.dart';
import 'package:help4kids/config/app_config.dart';
import 'package:help4kids/services/auth_service.dart';
import 'package:help4kids/models/user.dart';
import 'package:bcrypt/bcrypt.dart';
import '../fake_connection_enhanced.dart';
import '../test_reqiuest_context.dart';
import '../../routes/api/consultation-appointments/index.dart' as appointments_index;
import '../../routes/api/consultation-appointments/[appointmentId]/process.dart' as appointments_process;

void main() {
  group('Consultation Appointments Routes', () {
    late User adminUser;
    late String adminToken;

    setUpAll(() {
      AppConfig.setTestConfig(
        jwtSecret: 'test-secret-key-for-testing-only',
        jwtIssuer: 'help4kids.com',
      );
    });

    tearDownAll(() {
      AppConfig.resetTestConfig();
    });

    setUp(() {
      // Create admin user and token
      // Note: Roles.isAdmin checks for roleId == 'admin' or 'god'
      // But JWT contains roleId from user, which might be a role ID
      // For testing, we'll use 'admin' directly as roleId in JWT
      adminUser = User(
        id: 'admin-1',
        email: 'admin@example.com',
        passwordHash: BCrypt.hashpw('password123', BCrypt.gensalt()),
        firstName: 'Admin',
        lastName: 'User',
        roleId: 'admin', // Use 'admin' directly for JWT (Roles.isAdmin checks this)
        isVerified: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      adminToken = AuthService.generateJwt(adminUser);

      final testData = <String, List<Map<String, dynamic>>>{
        'users': [
          {
            'id': 'admin-1',
            'email': 'admin@example.com',
            'password_hash': adminUser.passwordHash,
            'first_name': 'Admin',
            'last_name': 'User',
            'role_id': 'admin',
            'is_verified': true,
            'created_at': DateTime.now(),
            'updated_at': DateTime.now(),
          },
          {
            'id': 'user-1',
            'email': 'user1@example.com',
            'password_hash': BCrypt.hashpw('password123', BCrypt.gensalt()),
            'first_name': 'User',
            'last_name': 'One',
            'role_id': 'customer',
            'is_verified': true,
            'created_at': DateTime.now(),
            'updated_at': DateTime.now(),
          },
        ],
        'roles': [
          {
            'id': 'admin',
            'name': 'admin',
          },
          {
            'id': 'customer',
            'name': 'customer',
          },
        ],
        'consultation_appointments': [
          {
            'id': '11111111-1111-1111-1111-111111111111',
            'consultation_id': 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'appointment_datetime': DateTime(2025, 1, 15, 10, 0),
            'details': 'Test details',
            'order_id': 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
            'processed': false,
            'processed_by': null,
            'processed_at': null,
            'doctor_id': 'dddddddd-dddd-dddd-dddd-dddddddddddd',
            'created_at': DateTime(2025, 1, 1, 10, 0),
            'updated_at': DateTime(2025, 1, 1, 10, 0),
          },
        ],
        'orders': [
          {
            'id': 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
            'user_id': 'iiiiiiii-iiii-iiii-iiii-iiiiiiiiiiii',
            'order_reference': 'REF-001',
            'service_type': 'consultation',
            'service_id': 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'amount': 500.0,
            'status': 'paid',
            'purchase_date': DateTime(2025, 1, 1, 9, 0),
            'created_at': DateTime(2025, 1, 1, 9, 0),
            'updated_at': DateTime(2025, 1, 1, 9, 0),
          },
        ],
        'users': [
          {
            'id': 'iiiiiiii-iiii-iiii-iiii-iiiiiiiiiiii',
            'email': 'user1@example.com',
            'name': 'User One',
          },
        ],
        'staff': [
          {
            'id': 'dddddddd-dddd-dddd-dddd-dddddddddddd',
            'name': 'Doctor One',
          },
        ],
        'consultations': [
          {
            'id': 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'title': 'Consultation One',
          },
        ],
      };

      MySQLConnection.connectionFactory = () async =>
          EnhancedFakeMySqlConnection(data: testData);
    });

    group('GET /api/consultation-appointments', () {
      test('returns 401 without authentication', () async {
        final request = Request.get(
          Uri.parse('http://localhost/api/consultation-appointments'),
        );
        final context = TestRequestContext(request: request);
        final response = await appointments_index.onRequest(context);

        expect(response.statusCode, equals(401));
      });

      test('returns 403 for non-admin user', () async {
        final customerUser = User(
          id: 'user-1',
          email: 'user1@example.com',
          passwordHash: 'hash',
          firstName: 'User',
          lastName: 'One',
          roleId: 'customer',
          isVerified: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        final customerToken = AuthService.generateJwt(customerUser);

        final request = Request.get(
          Uri.parse('http://localhost/api/consultation-appointments'),
          headers: {'Authorization': 'Bearer $customerToken'},
        );
        final context = TestRequestContext(request: request);
        final response = await appointments_index.onRequest(context);

        expect(response.statusCode, equals(403));
      });

      test('returns appointments for admin user', () async {
        final request = Request.get(
          Uri.parse('http://localhost/api/consultation-appointments'),
          headers: {'Authorization': 'Bearer $adminToken'},
        );
        final context = TestRequestContext(request: request);
        final response = await appointments_index.onRequest(context);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body.containsKey('appointments'), isTrue);
        expect(body['appointments'], isA<List>());
      });

      test('filters by userId query parameter', () async {
        final request = Request.get(
          Uri.parse('http://localhost/api/consultation-appointments?userId=iiiiiiii-iiii-iiii-iiii-iiiiiiiiiiii'),
          headers: {'Authorization': 'Bearer $adminToken'},
        );
        final context = TestRequestContext(request: request);
        final response = await appointments_index.onRequest(context);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['appointments'], isA<List>());
      });

      test('filters by doctorId query parameter', () async {
        final request = Request.get(
          Uri.parse('http://localhost/api/consultation-appointments?doctorId=dddddddd-dddd-dddd-dddd-dddddddddddd'),
          headers: {'Authorization': 'Bearer $adminToken'},
        );
        final context = TestRequestContext(request: request);
        final response = await appointments_index.onRequest(context);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['appointments'], isA<List>());
      });

      test('filters by processed query parameter', () async {
        final request = Request.get(
          Uri.parse('http://localhost/api/consultation-appointments?processed=false'),
          headers: {'Authorization': 'Bearer $adminToken'},
        );
        final context = TestRequestContext(request: request);
        final response = await appointments_index.onRequest(context);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['appointments'], isA<List>());
      });

      test('filters by date range (from)', () async {
        final request = Request.get(
          Uri.parse('http://localhost/api/consultation-appointments?from=2025-01-15T00:00:00Z'),
          headers: {'Authorization': 'Bearer $adminToken'},
        );
        final context = TestRequestContext(request: request);
        final response = await appointments_index.onRequest(context);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['appointments'], isA<List>());
      });

      test('returns 400 for invalid date format', () async {
        final request = Request.get(
          Uri.parse('http://localhost/api/consultation-appointments?from=invalid-date'),
          headers: {'Authorization': 'Bearer $adminToken'},
        );
        final context = TestRequestContext(request: request);
        final response = await appointments_index.onRequest(context);

        expect(response.statusCode, equals(400));
      });

      test('returns 400 for invalid processed value', () async {
        final request = Request.get(
          Uri.parse('http://localhost/api/consultation-appointments?processed=maybe'),
          headers: {'Authorization': 'Bearer $adminToken'},
        );
        final context = TestRequestContext(request: request);
        final response = await appointments_index.onRequest(context);

        expect(response.statusCode, equals(400));
      });
    });

    group('POST /api/consultation-appointments/{id}/process', () {
      test('returns 401 without authentication', () async {
        final request = Request.post(
          Uri.parse('http://localhost/api/consultation-appointments/appt-1/process'),
        );
        final context = TestRequestContext(request: request);
        final response = await appointments_process.onRequest(context, 'appt-1');

        expect(response.statusCode, equals(401));
      });

      test('returns 403 for non-admin user', () async {
        final customerUser = User(
          id: 'user-1',
          email: 'user1@example.com',
          passwordHash: 'hash',
          firstName: 'User',
          lastName: 'One',
          roleId: 'customer',
          isVerified: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        final customerToken = AuthService.generateJwt(customerUser);

        final request = Request.post(
          Uri.parse('http://localhost/api/consultation-appointments/appt-1/process'),
          headers: {'Authorization': 'Bearer $customerToken'},
        );
        final context = TestRequestContext(request: request);
        final response = await appointments_process.onRequest(context, 'appt-1');

        expect(response.statusCode, equals(403));
      });

      test('marks appointment as processed for admin', () async {
        final request = Request.post(
          Uri.parse('http://localhost/api/consultation-appointments/11111111-1111-1111-1111-111111111111/process'),
          headers: {'Authorization': 'Bearer $adminToken'},
        );
        final context = TestRequestContext(request: request);
        final response = await appointments_process.onRequest(context, '11111111-1111-1111-1111-111111111111');

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body.containsKey('message'), isTrue);
        expect(body['message'], contains('processed'));
      });

      test('returns 404 for non-existent appointment', () async {
        final request = Request.post(
          Uri.parse('http://localhost/api/consultation-appointments/99999999-9999-9999-9999-999999999999/process'),
          headers: {'Authorization': 'Bearer $adminToken'},
        );
        final context = TestRequestContext(request: request);
        final response = await appointments_process.onRequest(context, '99999999-9999-9999-9999-999999999999');

        expect(response.statusCode, equals(404));
      });

      test('returns 400 for invalid appointment ID format', () async {
        final request = Request.post(
          Uri.parse('http://localhost/api/consultation-appointments/invalid-id/process'),
          headers: {'Authorization': 'Bearer $adminToken'},
        );
        final context = TestRequestContext(request: request);
        final response = await appointments_process.onRequest(context, 'invalid-id');

        expect(response.statusCode, equals(400));
      });

      test('returns 405 for non-POST method', () async {
        final request = Request.get(
          Uri.parse('http://localhost/api/consultation-appointments/11111111-1111-1111-1111-111111111111/process'),
          headers: {'Authorization': 'Bearer $adminToken'},
        );
        final context = TestRequestContext(request: request);
        final response = await appointments_process.onRequest(context, '11111111-1111-1111-1111-111111111111');

        expect(response.statusCode, equals(405));
      });
    });
  });
}


