import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/content_service.dart';
import 'package:help4kids/models/episode.dart';
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

    // GET /api/admin/contents/{contentId}/episodes - Get all episodes
    if (context.request.method == HttpMethod.get) {
      try {
        final episodes = await ContentService.getEpisodesByContentId(contentId);
        return ResponseHelpers.success({
          'episodes': episodes.map((e) => e.toJson()).toList(),
        });
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to fetch episodes'),
        );
      }
    }

    // POST /api/admin/contents/{contentId}/episodes - Create new episode
    if (context.request.method == HttpMethod.post) {
      try {
        final payload = context.read<JwtPayload>();
        final body = await context.request.json() as Map<String, dynamic>;

        // Validate required fields
        final title = body['title'] as String?;
        if (title == null || !Validation.isNotEmpty(title)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Title is required'),
          );
        }

        final episode = await ContentService.createEpisode(
          contentId: contentId,
          title: title,
          description: body['description'] as String?,
          videoUrl: body['videoUrl'] as String?,
          videoProvider: body['videoProvider'] as String?,
          ordering: (body['ordering'] as num?)?.toInt() ?? 0,
          durationSeconds: body['durationSeconds'] != null
              ? (body['durationSeconds'] as num).toInt()
              : null,
          createdBy: payload.id,
        );

        return ResponseHelpers.success(episode.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to create episode: ${e.toString()}'),
        );
      }
    }

    return ResponseHelpers.methodNotAllowed();
  });

  return handler(context);
}

