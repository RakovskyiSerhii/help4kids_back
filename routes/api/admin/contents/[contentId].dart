import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/content_service.dart';
import 'package:help4kids/models/content.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context, String contentId) async {
  final handler = requireAdmin((context) async {
    // Validate content ID format
    if (!Validation.isValidUuid(contentId)) {
      return ResponseHelpers.error(
        ApiErrors.validationError('Invalid content ID format'),
      );
    }

    // GET /api/admin/contents/{contentId} - Get content details
    if (context.request.method == HttpMethod.get) {
      try {
        final content = await ContentService.getContentById(contentId);
        if (content == null) {
          return ResponseHelpers.error(ApiErrors.notFound('Content'));
        }

        // Get related data
        final prices = await ContentService.getContentPrices(contentId);
        final episodes = content.contentType == ContentType.multiEpisode
            ? await ContentService.getEpisodesByContentId(contentId)
            : <Episode>[];
        final materials = await ContentService.getMaterials(contentId: contentId);

        return ResponseHelpers.success({
          'content': content.toJson(),
          'prices': prices.map((p) => p.toJson()).toList(),
          'episodes': episodes.map((e) => e.toJson()).toList(),
          'materials': materials.map((m) => m.toJson()).toList(),
        });
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to fetch content'),
        );
      }
    }

    // PUT /api/admin/contents/{contentId} - Update content
    if (context.request.method == HttpMethod.put) {
      try {
        final payload = context.read<JwtPayload>();
        final body = await context.request.json() as Map<String, dynamic>;

        final updates = <String, dynamic>{};

        if (body.containsKey('title')) {
          if (!Validation.isNotEmpty(body['title'] as String?)) {
            return ResponseHelpers.error(
              ApiErrors.validationError('Title cannot be empty'),
            );
          }
          updates['title'] = body['title'];
        }
        if (body.containsKey('description')) {
          updates['description'] = body['description'];
        }
        if (body.containsKey('shortDescription')) {
          updates['shortDescription'] = body['shortDescription'];
        }
        if (body.containsKey('telegramGroupUrl')) {
          updates['telegramGroupUrl'] = body['telegramGroupUrl'];
        }
        if (body.containsKey('coverImageUrl')) {
          updates['coverImageUrl'] = body['coverImageUrl'];
        }
        if (body.containsKey('contentType')) {
          try {
            updates['contentType'] = ContentType.values.firstWhere(
              (e) => e.name == body['contentType'],
            );
          } catch (e) {
            return ResponseHelpers.error(
              ApiErrors.validationError('Invalid contentType'),
            );
          }
        }
        if (body.containsKey('videoUrl')) {
          updates['videoUrl'] = body['videoUrl'];
        }
        if (body.containsKey('videoProvider')) {
          updates['videoProvider'] = body['videoProvider'];
        }
        if (body.containsKey('featured')) {
          updates['featured'] = body['featured'] as bool;
        }
        if (body.containsKey('ordering')) {
          updates['ordering'] = (body['ordering'] as num).toInt();
        }
        if (body.containsKey('isActive')) {
          updates['isActive'] = body['isActive'] as bool;
        }

        if (updates.isEmpty) {
          return ResponseHelpers.error(
            ApiErrors.validationError('No valid fields to update'),
          );
        }

        final success = await ContentService.updateContent(
          contentId,
          updates,
          updatedBy: payload.id,
        );

        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Failed to update content'),
          );
        }

        final updatedContent = await ContentService.getContentById(contentId);
        return ResponseHelpers.success(updatedContent?.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to update content: ${e.toString()}'),
        );
      }
    }

    // DELETE /api/admin/contents/{contentId} - Delete content
    if (context.request.method == HttpMethod.delete) {
      try {
        final hardDelete = context.request.url.queryParameters['hardDelete'] == 'true';
        final success = await ContentService.deleteContent(
          contentId,
          hardDelete: hardDelete,
        );

        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Failed to delete content'),
          );
        }

        return ResponseHelpers.success({'message': 'Content deleted successfully'});
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to delete content'),
        );
      }
    }

    return ResponseHelpers.methodNotAllowed();
  });

  return handler(context);
}

