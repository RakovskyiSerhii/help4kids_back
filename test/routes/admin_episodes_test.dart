import 'dart:convert';
import 'package:test/test.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/routes/api/admin/contents/[contentId]/episodes/index.dart' as episodes_index;
import 'package:help4kids/routes/api/admin/contents/[contentId]/episodes/[episodeId].dart' as episode_detail;
import 'package:help4kids/services/content_service.dart';
import 'package:help4kids/data/mysql_connection.dart';
import 'package:help4kids/config/app_config.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/models/content.dart';
import '../fake_connection_enhanced.dart' as fake_conn;
import '../test_reqiuest_context.dart';

void main() {
  group('Admin Episodes API', () {
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
        'episodes': [],
        'content_materials': [],
      };

      MySQLConnection.connectionFactory = () async =>
          fake_conn.EnhancedFakeMySqlConnection(data: testData);
    });

    group('GET /api/admin/contents/{contentId}/episodes', () {
      test('returns list of episodes', () async {
        final content = await ContentService.createContent(
          title: 'Test Course',
          contentType: ContentType.multiEpisode,
        );

        await ContentService.createEpisode(
          contentId: content.id,
          title: 'Episode 1',
        );

        final request = Request.get(
          Uri.parse('http://localhost/api/admin/contents/${content.id}/episodes'),
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

        final response = await episodes_index.onRequest(context, content.id);
        expect(response.statusCode, equals(200));

        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['success'], isTrue);
        expect(body['data']['episodes'], isA<List>());
      });
    });

    group('POST /api/admin/contents/{contentId}/episodes', () {
      test('creates episode', () async {
        final content = await ContentService.createContent(
          title: 'Test Course',
          contentType: ContentType.multiEpisode,
        );

        final request = Request.post(
          Uri.parse('http://localhost/api/admin/contents/${content.id}/episodes'),
          headers: {
            'Authorization': 'Bearer valid-token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'title': 'Episode 1',
            'description': 'First episode',
            'videoUrl': 'https://example.com/ep1',
            'ordering': 1,
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

        final response = await episodes_index.onRequest(context, content.id);
        expect(response.statusCode, equals(200));

        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['success'], isTrue);
        expect(body['data']['title'], equals('Episode 1'));
      });

      test('rejects episode without title', () async {
        final content = await ContentService.createContent(
          title: 'Test Course',
          contentType: ContentType.multiEpisode,
        );

        final request = Request.post(
          Uri.parse('http://localhost/api/admin/contents/${content.id}/episodes'),
          headers: {
            'Authorization': 'Bearer valid-token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'description': 'No title',
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

        final response = await episodes_index.onRequest(context, content.id);
        expect(response.statusCode, equals(400));
      });
    });

    group('GET /api/admin/contents/{contentId}/episodes/{episodeId}', () {
      test('returns episode with materials', () async {
        final content = await ContentService.createContent(
          title: 'Test Course',
          contentType: ContentType.multiEpisode,
        );

        final episode = await ContentService.createEpisode(
          contentId: content.id,
          title: 'Episode 1',
        );

        final request = Request.get(
          Uri.parse('http://localhost/api/admin/contents/${content.id}/episodes/${episode.id}'),
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

        final response = await episode_detail.onRequest(context, content.id, episode.id);
        expect(response.statusCode, equals(200));

        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['success'], isTrue);
        expect(body['data']['episode'], isNotNull);
        expect(body['data']['materials'], isA<List>());
      });
    });

    group('PUT /api/admin/contents/{contentId}/episodes/{episodeId}', () {
      test('updates episode', () async {
        final content = await ContentService.createContent(
          title: 'Test Course',
          contentType: ContentType.multiEpisode,
        );

        final episode = await ContentService.createEpisode(
          contentId: content.id,
          title: 'Original',
        );

        final request = Request.put(
          Uri.parse('http://localhost/api/admin/contents/${content.id}/episodes/${episode.id}'),
          headers: {
            'Authorization': 'Bearer valid-token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'title': 'Updated Title',
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

        final response = await episode_detail.onRequest(context, content.id, episode.id);
        expect(response.statusCode, equals(200));

        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['success'], isTrue);
        expect(body['data']['title'], equals('Updated Title'));
      });
    });

    group('DELETE /api/admin/contents/{contentId}/episodes/{episodeId}', () {
      test('deletes episode', () async {
        final content = await ContentService.createContent(
          title: 'Test Course',
          contentType: ContentType.multiEpisode,
        );

        final episode = await ContentService.createEpisode(
          contentId: content.id,
          title: 'To Delete',
        );

        final request = Request.delete(
          Uri.parse('http://localhost/api/admin/contents/${content.id}/episodes/${episode.id}'),
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

        final response = await episode_detail.onRequest(context, content.id, episode.id);
        expect(response.statusCode, equals(200));

        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['success'], isTrue);
      });
    });
  });
}

