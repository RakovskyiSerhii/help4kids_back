import 'dart:convert';
import 'package:test/test.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/routes/api/admin/contents/[contentId]/prices/index.dart' as prices_index;
import 'package:help4kids/routes/api/admin/contents/[contentId]/prices/[priceId].dart' as price_detail;
import 'package:help4kids/services/content_service.dart';
import 'package:help4kids/data/mysql_connection.dart';
import 'package:help4kids/config/app_config.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/models/content.dart';
import '../fake_connection_enhanced.dart' as fake_conn;
import '../test_reqiuest_context.dart';

void main() {
  group('Admin Content Prices API', () {
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
        'contents': [],
        'content_prices': [],
      };

      MySQLConnection.connectionFactory = () async =>
          fake_conn.EnhancedFakeMySqlConnection(data: testData);
    });

    group('GET /api/admin/contents/{contentId}/prices', () {
      test('returns list of prices for content', () async {
        final content = await ContentService.createContent(
          title: 'Test Content',
          contentType: ContentType.singleVideo,
        );

        await ContentService.createContentPrice(
          contentId: content.id,
          price: 1000.0,
          accessType: AccessType.lifetime,
        );

        final request = Request.get(
          Uri.parse('http://localhost/api/admin/contents/${content.id}/prices'),
          headers: {'Authorization': 'Bearer valid-token'},
        );

        final jwtPayload = JwtPayload(
          id: 'admin-123',
          email: 'admin@test.com',
          roleId: 'admin',
        );

        final context = TestRequestContext(
          request: request,
          properties: {JwtPayload: jwtPayload},
        );

        final response = await prices_index.onRequest(context, content.id);
        expect(response.statusCode, equals(200));

        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['success'], isTrue);
        expect(body['data']['prices'], isA<List>());
      });
    });

    group('POST /api/admin/contents/{contentId}/prices', () {
      test('creates lifetime price', () async {
        final content = await ContentService.createContent(
          title: 'Test Content',
          contentType: ContentType.singleVideo,
        );

        final request = Request.post(
          Uri.parse('http://localhost/api/admin/contents/${content.id}/prices'),
          headers: {
            'Authorization': 'Bearer valid-token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'price': 2000.0,
            'currency': 'UAH',
            'accessType': 'lifetime',
            'description': 'Довічний доступ',
            'isDefault': true,
          }),
        );

        final jwtPayload = JwtPayload(
          id: 'admin-123',
          email: 'admin@test.com',
          roleId: 'admin',
        );

        final context = TestRequestContext(
          request: request,
          properties: {JwtPayload: jwtPayload},
        );

        final response = await prices_index.onRequest(context, content.id);
        expect(response.statusCode, equals(200));

        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['success'], isTrue);
        expect(body['data']['price'], equals(2000.0));
        expect(body['data']['accessType'], equals('lifetime'));
      });

      test('creates time-limited price', () async {
        final content = await ContentService.createContent(
          title: 'Test Content',
          contentType: ContentType.singleVideo,
        );

        final request = Request.post(
          Uri.parse('http://localhost/api/admin/contents/${content.id}/prices'),
          headers: {
            'Authorization': 'Bearer valid-token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'price': 1000.0,
            'accessType': 'timeLimited',
            'accessDurationMonths': 6,
            'description': 'Доступ на 6 місяців',
          }),
        );

        final jwtPayload = JwtPayload(
          id: 'admin-123',
          email: 'admin@test.com',
          roleId: 'admin',
        );

        final context = TestRequestContext(
          request: request,
          properties: {JwtPayload: jwtPayload},
        );

        final response = await prices_index.onRequest(context, content.id);
        expect(response.statusCode, equals(200));

        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['success'], isTrue);
        expect(body['data']['accessType'], equals('timeLimited'));
        expect(body['data']['accessDurationMonths'], equals(6));
      });

      test('rejects invalid price', () async {
        final content = await ContentService.createContent(
          title: 'Test Content',
          contentType: ContentType.singleVideo,
        );

        final request = Request.post(
          Uri.parse('http://localhost/api/admin/contents/${content.id}/prices'),
          headers: {
            'Authorization': 'Bearer valid-token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'price': -100,
            'accessType': 'lifetime',
          }),
        );

        final jwtPayload = JwtPayload(
          id: 'admin-123',
          email: 'admin@test.com',
          roleId: 'admin',
        );

        final context = TestRequestContext(
          request: request,
          properties: {JwtPayload: jwtPayload},
        );

        final response = await prices_index.onRequest(context, content.id);
        expect(response.statusCode, equals(400));
      });

      test('rejects time-limited without duration', () async {
        final content = await ContentService.createContent(
          title: 'Test Content',
          contentType: ContentType.singleVideo,
        );

        final request = Request.post(
          Uri.parse('http://localhost/api/admin/contents/${content.id}/prices'),
          headers: {
            'Authorization': 'Bearer valid-token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'price': 1000.0,
            'accessType': 'timeLimited',
          }),
        );

        final jwtPayload = JwtPayload(
          id: 'admin-123',
          email: 'admin@test.com',
          roleId: 'admin',
        );

        final context = TestRequestContext(
          request: request,
          properties: {JwtPayload: jwtPayload},
        );

        final response = await prices_index.onRequest(context, content.id);
        expect(response.statusCode, equals(400));
      });
    });

    group('PUT /api/admin/contents/{contentId}/prices/{priceId}', () {
      test('updates price', () async {
        final content = await ContentService.createContent(
          title: 'Test Content',
          contentType: ContentType.singleVideo,
        );

        final price = await ContentService.createContentPrice(
          contentId: content.id,
          price: 1000.0,
          accessType: AccessType.lifetime,
        );

        final request = Request.put(
          Uri.parse('http://localhost/api/admin/contents/${content.id}/prices/${price.id}'),
          headers: {
            'Authorization': 'Bearer valid-token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'price': 1500.0,
          }),
        );

        final jwtPayload = JwtPayload(
          id: 'admin-123',
          email: 'admin@test.com',
          roleId: 'admin',
        );

        final context = TestRequestContext(
          request: request,
          properties: {JwtPayload: jwtPayload},
        );

        final response = await price_detail.onRequest(context, content.id, price.id);
        expect(response.statusCode, equals(200));

        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['success'], isTrue);
        expect(body['data']['price'], equals(1500.0));
      });
    });

    group('DELETE /api/admin/contents/{contentId}/prices/{priceId}', () {
      test('deletes price', () async {
        final content = await ContentService.createContent(
          title: 'Test Content',
          contentType: ContentType.singleVideo,
        );

        final price = await ContentService.createContentPrice(
          contentId: content.id,
          price: 1000.0,
          accessType: AccessType.lifetime,
        );

        final request = Request.delete(
          Uri.parse('http://localhost/api/admin/contents/${content.id}/prices/${price.id}'),
          headers: {'Authorization': 'Bearer valid-token'},
        );

        final jwtPayload = JwtPayload(
          id: 'admin-123',
          email: 'admin@test.com',
          roleId: 'admin',
        );

        final context = TestRequestContext(
          request: request,
          properties: {JwtPayload: jwtPayload},
        );

        final response = await price_detail.onRequest(context, content.id, price.id);
        expect(response.statusCode, equals(200));

        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['success'], isTrue);
      });
    });
  });
}

