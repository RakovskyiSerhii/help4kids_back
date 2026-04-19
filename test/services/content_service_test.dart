import 'package:test/test.dart';
import 'package:help4kids/services/content_service.dart';
import 'package:help4kids/models/content.dart';
import 'package:help4kids/models/content_price.dart';
import 'package:help4kids/models/episode.dart';
import 'package:help4kids/models/content_material.dart';
import 'package:help4kids/data/mysql_connection.dart';
import '../fake_connection_enhanced.dart' as fake_conn;

void main() {
  group('ContentService', () {
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

    tearDown(() {
      // Connection will be reset automatically
    });

    group('Content CRUD', () {
      test('createContent creates single video content', () async {
        final content = await ContentService.createContent(
          title: 'Test Webinar',
          description: 'Test description',
          contentType: ContentType.singleVideo,
          videoUrl: 'https://example.com/video',
          videoProvider: 'bunny',
        );

        expect(content, isNotNull);
        expect(content.title, equals('Test Webinar'));
        expect(content.contentType, equals(ContentType.singleVideo));
        expect(content.videoUrl, equals('https://example.com/video'));
        expect(content.isActive, isTrue);
      });

      test('createContent creates multi-episode content', () async {
        final content = await ContentService.createContent(
          title: 'Test Course',
          description: 'Test course description',
          contentType: ContentType.multiEpisode,
        );

        expect(content, isNotNull);
        expect(content.title, equals('Test Course'));
        expect(content.contentType, equals(ContentType.multiEpisode));
        expect(content.videoUrl, isNull);
      });

      test('getContentById returns content', () async {
        // First create content
        final created = await ContentService.createContent(
          title: 'Test Content',
          contentType: ContentType.singleVideo,
        );

        // Then retrieve it
        final retrieved = await ContentService.getContentById(created.id);
        expect(retrieved, isNotNull);
        expect(retrieved?.id, equals(created.id));
        expect(retrieved?.title, equals('Test Content'));
      });

      test('getContentById returns null for non-existent content', () async {
        final content = await ContentService.getContentById('non-existent-id');
        expect(content, isNull);
      });

      test('getAllContents returns all contents', () async {
        await ContentService.createContent(
          title: 'Content 1',
          contentType: ContentType.singleVideo,
        );
        await ContentService.createContent(
          title: 'Content 2',
          contentType: ContentType.multiEpisode,
        );

        final contents = await ContentService.getAllContents();
        expect(contents.length, greaterThanOrEqualTo(2));
      });

      test('getAllContents filters by isActive', () async {
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

        final activeContents = await ContentService.getAllContents(isActive: true);
        expect(activeContents.every((c) => c.isActive), isTrue);
      });

      test('updateContent updates content fields', () async {
        final content = await ContentService.createContent(
          title: 'Original Title',
          contentType: ContentType.singleVideo,
        );

        final success = await ContentService.updateContent(
          content.id,
          {'title': 'Updated Title', 'description': 'New description'},
        );

        expect(success, isTrue);

        final updated = await ContentService.getContentById(content.id);
        expect(updated?.title, equals('Updated Title'));
        expect(updated?.description, equals('New description'));
      });

      test('deleteContent soft deletes content', () async {
        final content = await ContentService.createContent(
          title: 'To Delete',
          contentType: ContentType.singleVideo,
        );

        final success = await ContentService.deleteContent(content.id);
        expect(success, isTrue);

        final deleted = await ContentService.getContentById(content.id);
        expect(deleted?.isActive, isFalse);
      });
    });

    group('Content Prices', () {
      test('createContentPrice creates price with lifetime access', () async {
        final content = await ContentService.createContent(
          title: 'Test Content',
          contentType: ContentType.singleVideo,
        );

        final price = await ContentService.createContentPrice(
          contentId: content.id,
          price: 1000.0,
          accessType: AccessType.lifetime,
        );

        expect(price, isNotNull);
        expect(price.price, equals(1000.0));
        expect(price.accessType, equals(AccessType.lifetime));
        expect(price.accessDurationMonths, isNull);
      });

      test('createContentPrice creates price with time-limited access', () async {
        final content = await ContentService.createContent(
          title: 'Test Content',
          contentType: ContentType.singleVideo,
        );

        final price = await ContentService.createContentPrice(
          contentId: content.id,
          price: 500.0,
          accessType: AccessType.timeLimited,
          accessDurationMonths: 6,
        );

        expect(price, isNotNull);
        expect(price.price, equals(500.0));
        expect(price.accessType, equals(AccessType.timeLimited));
        expect(price.accessDurationMonths, equals(6));
      });

      test('getContentPrices returns all prices for content', () async {
        final content = await ContentService.createContent(
          title: 'Test Content',
          contentType: ContentType.singleVideo,
        );

        await ContentService.createContentPrice(
          contentId: content.id,
          price: 1000.0,
          accessType: AccessType.lifetime,
        );
        await ContentService.createContentPrice(
          contentId: content.id,
          price: 500.0,
          accessType: AccessType.timeLimited,
          accessDurationMonths: 6,
        );

        final prices = await ContentService.getContentPrices(content.id);
        expect(prices.length, equals(2));
      });

      test('updateContentPrice updates price', () async {
        final content = await ContentService.createContent(
          title: 'Test Content',
          contentType: ContentType.singleVideo,
        );

        final price = await ContentService.createContentPrice(
          contentId: content.id,
          price: 1000.0,
          accessType: AccessType.lifetime,
        );

        final success = await ContentService.updateContentPrice(
          price.id,
          {'price': 1500.0},
        );

        expect(success, isTrue);

        final updated = await ContentService.getContentPriceById(price.id);
        expect(updated?.price, equals(1500.0));
      });

      test('deleteContentPrice removes price', () async {
        final content = await ContentService.createContent(
          title: 'Test Content',
          contentType: ContentType.singleVideo,
        );

        final price = await ContentService.createContentPrice(
          contentId: content.id,
          price: 1000.0,
          accessType: AccessType.lifetime,
        );

        final success = await ContentService.deleteContentPrice(price.id);
        expect(success, isTrue);

        final deleted = await ContentService.getContentPriceById(price.id);
        expect(deleted, isNull);
      });
    });

    group('Episodes', () {
      test('createEpisode creates episode', () async {
        final content = await ContentService.createContent(
          title: 'Test Course',
          contentType: ContentType.multiEpisode,
        );

        final episode = await ContentService.createEpisode(
          contentId: content.id,
          title: 'Episode 1',
          description: 'First episode',
          videoUrl: 'https://example.com/ep1',
        );

        expect(episode, isNotNull);
        expect(episode.title, equals('Episode 1'));
        expect(episode.contentId, equals(content.id));
        expect(episode.videoUrl, equals('https://example.com/ep1'));
      });

      test('getEpisodesByContentId returns episodes for content', () async {
        final content = await ContentService.createContent(
          title: 'Test Course',
          contentType: ContentType.multiEpisode,
        );

        await ContentService.createEpisode(
          contentId: content.id,
          title: 'Episode 1',
          ordering: 1,
        );
        await ContentService.createEpisode(
          contentId: content.id,
          title: 'Episode 2',
          ordering: 2,
        );

        final episodes = await ContentService.getEpisodesByContentId(content.id);
        expect(episodes.length, equals(2));
        expect(episodes[0].ordering, lessThan(episodes[1].ordering));
      });

      test('updateEpisode updates episode', () async {
        final content = await ContentService.createContent(
          title: 'Test Course',
          contentType: ContentType.multiEpisode,
        );

        final episode = await ContentService.createEpisode(
          contentId: content.id,
          title: 'Original Title',
        );

        final success = await ContentService.updateEpisode(
          episode.id,
          {'title': 'Updated Title'},
        );

        expect(success, isTrue);

        final updated = await ContentService.getEpisodeById(episode.id);
        expect(updated?.title, equals('Updated Title'));
      });

      test('deleteEpisode removes episode', () async {
        final content = await ContentService.createContent(
          title: 'Test Course',
          contentType: ContentType.multiEpisode,
        );

        final episode = await ContentService.createEpisode(
          contentId: content.id,
          title: 'To Delete',
        );

        final success = await ContentService.deleteEpisode(episode.id);
        expect(success, isTrue);

        final deleted = await ContentService.getEpisodeById(episode.id);
        expect(deleted, isNull);
      });
    });

    group('Content Materials', () {
      test('createContentMaterial creates material for content', () async {
        final content = await ContentService.createContent(
          title: 'Test Content',
          contentType: ContentType.singleVideo,
        );

        final material = await ContentService.createContentMaterial(
          contentId: content.id,
          materialType: MaterialType.pdf,
          title: 'Test PDF',
          fileUrl: '/materials/test.pdf',
        );

        expect(material, isNotNull);
        expect(material.title, equals('Test PDF'));
        expect(material.contentId, equals(content.id));
        expect(material.episodeId, isNull);
        expect(material.materialType, equals(MaterialType.pdf));
      });

      test('createContentMaterial creates material for episode', () async {
        final content = await ContentService.createContent(
          title: 'Test Course',
          contentType: ContentType.multiEpisode,
        );

        final episode = await ContentService.createEpisode(
          contentId: content.id,
          title: 'Episode 1',
        );

        final material = await ContentService.createContentMaterial(
          episodeId: episode.id,
          materialType: MaterialType.image,
          title: 'Test Image',
          fileUrl: '/materials/test.jpg',
        );

        expect(material, isNotNull);
        expect(material.episodeId, equals(episode.id));
        expect(material.contentId, isNull);
      });

      test('getMaterials returns materials for content', () async {
        final content = await ContentService.createContent(
          title: 'Test Content',
          contentType: ContentType.singleVideo,
        );

        await ContentService.createContentMaterial(
          contentId: content.id,
          materialType: MaterialType.pdf,
          title: 'Material 1',
          fileUrl: '/materials/1.pdf',
        );
        await ContentService.createContentMaterial(
          contentId: content.id,
          materialType: MaterialType.link,
          title: 'Material 2',
          externalUrl: 'https://example.com',
        );

        final materials = await ContentService.getMaterials(contentId: content.id);
        expect(materials.length, equals(2));
      });

      test('deleteContentMaterial removes material', () async {
        final content = await ContentService.createContent(
          title: 'Test Content',
          contentType: ContentType.singleVideo,
        );

        final material = await ContentService.createContentMaterial(
          contentId: content.id,
          materialType: MaterialType.pdf,
          title: 'To Delete',
          fileUrl: '/materials/delete.pdf',
        );

        final success = await ContentService.deleteContentMaterial(material.id);
        expect(success, isTrue);
      });
    });
  });
}

