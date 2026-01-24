import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/content_service.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(
  RequestContext context,
  String contentId,
  String episodeId,
) async {
  final handler = requireAdmin((context) async {
    // Validate IDs
    if (!Validation.isValidUuid(contentId) || !Validation.isValidUuid(episodeId)) {
      return ResponseHelpers.error(
        ApiErrors.validationError('Invalid ID format'),
      );
    }

    // GET /api/admin/contents/{contentId}/episodes/{episodeId} - Get episode
    if (context.request.method == HttpMethod.get) {
      try {
        final episode = await ContentService.getEpisodeById(episodeId);
        if (episode == null) {
          return ResponseHelpers.error(ApiErrors.notFound('Episode'));
        }

        // Get materials for episode
        final materials = await ContentService.getMaterials(episodeId: episodeId);

        return ResponseHelpers.success({
          'episode': episode.toJson(),
          'materials': materials.map((m) => m.toJson()).toList(),
        });
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to fetch episode'),
        );
      }
    }

    // PUT /api/admin/contents/{contentId}/episodes/{episodeId} - Update episode
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
        if (body.containsKey('videoUrl')) {
          updates['videoUrl'] = body['videoUrl'];
        }
        if (body.containsKey('videoProvider')) {
          updates['videoProvider'] = body['videoProvider'];
        }
        if (body.containsKey('ordering')) {
          updates['ordering'] = (body['ordering'] as num).toInt();
        }
        if (body.containsKey('durationSeconds')) {
          updates['durationSeconds'] = (body['durationSeconds'] as num).toInt();
        }

        if (updates.isEmpty) {
          return ResponseHelpers.error(
            ApiErrors.validationError('No valid fields to update'),
          );
        }

        final success = await ContentService.updateEpisode(
          episodeId,
          updates,
          updatedBy: payload.id,
        );

        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Failed to update episode'),
          );
        }

        final updatedEpisode = await ContentService.getEpisodeById(episodeId);
        return ResponseHelpers.success(updatedEpisode?.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to update episode: ${e.toString()}'),
        );
      }
    }

    // DELETE /api/admin/contents/{contentId}/episodes/{episodeId} - Delete episode
    if (context.request.method == HttpMethod.delete) {
      try {
        final success = await ContentService.deleteEpisode(episodeId);
        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Failed to delete episode'),
          );
        }
        return ResponseHelpers.success({'message': 'Episode deleted successfully'});
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to delete episode'),
        );
      }
    }

    return ResponseHelpers.methodNotAllowed();
  });

  return handler(context);
}

