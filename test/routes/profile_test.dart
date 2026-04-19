import 'dart:convert';
import 'package:test/test.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/routes/api/auth/me.dart' as me_route;
import 'package:help4kids/services/auth_service.dart';
import 'package:help4kids/data/mysql_connection.dart';
import 'package:help4kids/config/app_config.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import '../fake_connection_enhanced.dart';
import '../test_reqiuest_context.dart';

void main() {
  group('Profile API', () {
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
          EnhancedFakeMySqlConnection(data: testData);
    });

    test('GET /api/auth/me returns user profile with phone', () async {
      final request = Request.get(
        Uri.parse('http://localhost/api/auth/me'),
        headers: {'Authorization': 'Bearer valid-token'},
      );

      final jwtPayload = JwtPayload(
        id: 'user-123',
        email: 'test@example.com',
        roleId: 'role-customer',
      );

      final context = TestRequestContext(
        request: request,
        properties: {JwtPayload: jwtPayload},
      );

      final response = await me_route.onRequest(context);
      expect(response.statusCode, equals(200));

      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['success'], isTrue);
      expect(body['data']['id'], equals('user-123'));
      expect(body['data']['email'], equals('test@example.com'));
      expect(body['data']['phone'], equals('+380501234567'));
      expect(body['data'], isNot(contains('passwordHash')));
    });

    test('PUT /api/auth/me updates phone number', () async {
      final request = Request.put(
        Uri.parse('http://localhost/api/auth/me'),
        headers: {
          'Authorization': 'Bearer valid-token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'phone': '+380509876543'}),
      );

      final jwtPayload = JwtPayload(
        id: 'user-123',
        email: 'test@example.com',
        roleId: 'role-customer',
      );

      final context = TestRequestContext(
        request: request,
        properties: {JwtPayload: jwtPayload},
      );

      final response = await me_route.onRequest(context);
      expect(response.statusCode, equals(200));

      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['success'], isTrue);
    });

    test('PUT /api/auth/me updates firstName', () async {
      final request = Request.put(
        Uri.parse('http://localhost/api/auth/me'),
        headers: {
          'Authorization': 'Bearer valid-token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'firstName': 'Updated'}),
      );

      final jwtPayload = JwtPayload(
        id: 'user-123',
        email: 'test@example.com',
        roleId: 'role-customer',
      );

      final context = TestRequestContext(
        request: request,
        properties: {JwtPayload: jwtPayload},
      );

      final response = await me_route.onRequest(context);
      expect(response.statusCode, equals(200));
    });

    test('PUT /api/auth/me updates multiple fields', () async {
      final request = Request.put(
        Uri.parse('http://localhost/api/auth/me'),
        headers: {
          'Authorization': 'Bearer valid-token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'firstName': 'New',
          'lastName': 'Name',
          'phone': '+380501111111',
        }),
      );

      final jwtPayload = JwtPayload(
        id: 'user-123',
        email: 'test@example.com',
        roleId: 'role-customer',
      );

      final context = TestRequestContext(
        request: request,
        properties: {JwtPayload: jwtPayload},
      );

      final response = await me_route.onRequest(context);
      expect(response.statusCode, equals(200));
    });

    test('PUT /api/auth/me rejects empty firstName', () async {
      final request = Request.put(
        Uri.parse('http://localhost/api/auth/me'),
        headers: {
          'Authorization': 'Bearer valid-token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'firstName': '   '}),
      );

      final jwtPayload = JwtPayload(
        id: 'user-123',
        email: 'test@example.com',
        roleId: 'role-customer',
      );

      final context = TestRequestContext(
        request: request,
        properties: {JwtPayload: jwtPayload},
      );

      final response = await me_route.onRequest(context);
      expect(response.statusCode, equals(400));
    });

    test('PUT /api/auth/me rejects too long phone', () async {
      final request = Request.put(
        Uri.parse('http://localhost/api/auth/me'),
        headers: {
          'Authorization': 'Bearer valid-token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'phone': 'a' * 51}), // 51 characters
      );

      final jwtPayload = JwtPayload(
        id: 'user-123',
        email: 'test@example.com',
        roleId: 'role-customer',
      );

      final context = TestRequestContext(
        request: request,
        properties: {JwtPayload: jwtPayload},
      );

      final response = await me_route.onRequest(context);
      expect(response.statusCode, equals(400));
    });

    test('PUT /api/auth/me rejects empty update data', () async {
      final request = Request.put(
        Uri.parse('http://localhost/api/auth/me'),
        headers: {
          'Authorization': 'Bearer valid-token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({}),
      );

      final jwtPayload = JwtPayload(
        id: 'user-123',
        email: 'test@example.com',
        roleId: 'role-customer',
      );

      final context = TestRequestContext(
        request: request,
        properties: {JwtPayload: jwtPayload},
      );

      final response = await me_route.onRequest(context);
      expect(response.statusCode, equals(400));
    });
  });
}

