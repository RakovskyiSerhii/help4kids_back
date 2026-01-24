import 'dart:convert';
import 'package:test/test.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/routes/api/admin/contents/index.dart' as contents_index;
import 'package:help4kids/routes/api/admin/contents/[contentId].dart' as content_detail;
import 'package:help4kids/services/content_service.dart';
import 'package:help4kids/data/mysql_connection.dart';
import 'package:help4kids/config/app_config.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/models/content.dart';
import '../fake_connection_enhanced.dart' as fake_conn;
import '../test_reqiuest_context.dart';

void main() {
  group('Admin Content API', () {
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
        'episodes': [],
        'content_materials': [],
      };

      MySQLConnection.connectionFactory = () async =>
          fake_conn.EnhancedFakeMySqlConnection(data: testData);
    });

    group('GET /api/admin/contents', () {
      test('returns list of contents', () async {
        // Create test content
        await ContentService.createContent(
          title: 'Test Content',
          contentType: ContentType.singleVideo,
        );

        final request = Request.get(
          Uri.parse('http://localhost/api/admin/contents'),
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

        final response = await contents_index.onRequest(context);
        expect(response.statusCode, equals(200));

        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['success'], isTrue);
        expect(body['data']['contents'], isA<List>());
      });

      test('filters by isActive parameter', () async {
        await ContentService.createContent(
          title: 'Active Content',
          contentType: ContentType.singleVideo,
          isActive: true,
        );
        await ContentService.createContent(
          title: 'Inactive Content',
          contentType: ContentType.singleVideo,
          isActive: false,
        );

        final request = Request.get(
          Uri.parse('http://localhost/api/admin/contents?isActive=true'),
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

        final response = await contents_index.onRequest(context);
        expect(response.statusCode, equals(200));

        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        final contents = body['data']['contents'] as List;
        expect(contents.every((c) => c['isActive'] == true), isTrue);
      });
    });

    group('POST /api/admin/contents', () {
      test('creates single video content', () async {
        final request = Request.post(
          Uri.parse('http://localhost/api/admin/contents'),
          headers: {
            'Authorization': 'Bearer valid-token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'title': 'Test Webinar',
            'description': 'Test description',
            'contentType': 'singleVideo',
            'videoUrl': 'https://example.com/video',
            'videoProvider': 'bunny',
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

        final response = await contents_index.onRequest(context);
        expect(response.statusCode, equals(200));

        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['success'], isTrue);
        expect(body['data']['title'], equals('Test Webinar'));
        expect(body['data']['contentType'], equals('singleVideo'));
      });

      test('creates multi-episode content', () async {
        final request = Request.post(
          Uri.parse('http://localhost/api/admin/contents'),
          headers: {
            'Authorization': 'Bearer valid-token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'title': 'Test Course',
            'description': 'Test course description',
            'contentType': 'multiEpisode',
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

        final response = await contents_index.onRequest(context);
        expect(response.statusCode, equals(200));

        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['success'], isTrue);
        expect(body['data']['contentType'], equals('multiEpisode'));
      });

      test('rejects content without title', () async {
        final request = Request.post(
          Uri.parse('http://localhost/api/admin/contents'),
          headers: {
            'Authorization': 'Bearer valid-token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'description': 'No title provided',
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

        final response = await contents_index.onRequest(context);
        expect(response.statusCode, equals(400));
      });

      test('rejects single video without videoUrl', () async {
        final request = Request.post(
          Uri.parse('http://localhost/api/admin/contents'),
          headers: {
            'Authorization': 'Bearer valid-token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'title': 'Test',
            'contentType': 'singleVideo',
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

        final response = await contents_index.onRequest(context);
        expect(response.statusCode, equals(400));
      });
    });

    group('GET /api/admin/contents/{contentId}', () {
      test('returns content with related data', () async {
        final content = await ContentService.createContent(
          title: 'Test Content',
          contentType: ContentType.singleVideo,
        );

        final request = Request.get(
          Uri.parse('http://localhost/api/admin/contents/${content.id}'),
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

        final response = await content_detail.onRequest(context, content.id);
        expect(response.statusCode, equals(200));

        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['success'], isTrue);
        expect(body['data']['content'], isNotNull);
        expect(body['data']['prices'], isA<List>());
        expect(body['data']['episodes'], isA<List>());
        expect(body['data']['materials'], isA<List>());
      });

      test('returns 404 for non-existent content', () async {
        final request = Request.get(
          Uri.parse('http://localhost/api/admin/contents/non-existent-id'),
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

        final response = await content_detail.onRequest(context, 'non-existent-id');
        expect(response.statusCode, equals(404));
      });
    });

    group('PUT /api/admin/contents/{contentId}', () {
      test('updates content', () async {
        final content = await ContentService.createContent(
          title: 'Original Title',
          contentType: ContentType.singleVideo,
        );

        final request = Request.put(
          Uri.parse('http://localhost/api/admin/contents/${content.id}'),
          headers: {
            'Authorization': 'Bearer valid-token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'title': 'Updated Title',
            'description': 'Updated description',
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

        final response = await content_detail.onRequest(context, content.id);
        expect(response.statusCode, equals(200));

        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['success'], isTrue);
        expect(body['data']['title'], equals('Updated Title'));
      });

      test('rejects empty title update', () async {
        final content = await ContentService.createContent(
          title: 'Original Title',
          contentType: ContentType.singleVideo,
        );

        final request = Request.put(
          Uri.parse('http://localhost/api/admin/contents/${content.id}'),
          headers: {
            'Authorization': 'Bearer valid-token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'title': '   ',
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

        final response = await content_detail.onRequest(context, content.id);
        expect(response.statusCode, equals(400));
      });
    });

    group('DELETE /api/admin/contents/{contentId}', () {
      test('soft deletes content', () async {
        final content = await ContentService.createContent(
          title: 'To Delete',
          contentType: ContentType.singleVideo,
        );

        final request = Request.delete(
          Uri.parse('http://localhost/api/admin/contents/${content.id}'),
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

        final response = await content_detail.onRequest(context, content.id);
        expect(response.statusCode, equals(200));

        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['success'], isTrue);

        // Verify content is soft deleted
        final deleted = await ContentService.getContentById(content.id);
        expect(deleted?.isActive, isFalse);
      });
    });
  });
}

