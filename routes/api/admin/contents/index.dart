import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/content_service.dart';
import 'package:help4kids/models/content.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context) async {
  final handler = requireAdmin((context) async {
    // GET /api/admin/contents - List all contents
    if (context.request.method == HttpMethod.get) {
      try {
        final isActiveParam = context.request.url.queryParameters['isActive'];
        final bool? isActive = isActiveParam != null
            ? isActiveParam.toLowerCase() == 'true'
            : null;

        final contents = await ContentService.getAllContents(isActive: isActive);
        return ResponseHelpers.success({
          'contents': contents.map((c) => c.toJson()).toList(),
        });
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to fetch contents'),
        );
      }
    }

    // POST /api/admin/contents - Create new content
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

        // Validate content type
        final contentTypeStr = body['contentType'] as String? ?? 'singleVideo';
        ContentType contentType;
        try {
          contentType = ContentType.values.firstWhere(
            (e) => e.name == contentTypeStr,
          );
        } catch (e) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Invalid contentType. Must be: singleVideo or multiEpisode'),
          );
        }

        // Validate single video has video URL
        if (contentType == ContentType.singleVideo) {
          final videoUrl = body['videoUrl'] as String?;
          if (videoUrl == null || !Validation.isNotEmpty(videoUrl)) {
            return ResponseHelpers.error(
              ApiErrors.validationError('videoUrl is required for single video content'),
            );
          }
        }

        final content = await ContentService.createContent(
          title: title,
          description: body['description'] as String?,
          shortDescription: body['shortDescription'] as String?,
          telegramGroupUrl: body['telegramGroupUrl'] as String?,
          coverImageUrl: body['coverImageUrl'] as String?,
          contentType: contentType,
          videoUrl: body['videoUrl'] as String?,
          videoProvider: body['videoProvider'] as String?,
          featured: body['featured'] as bool? ?? false,
          ordering: (body['ordering'] as num?)?.toInt() ?? 0,
          isActive: body['isActive'] as bool? ?? true,
          createdBy: payload.id,
        );

        return ResponseHelpers.success(content.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to create content: ${e.toString()}'),
        );
      }
    }

    return ResponseHelpers.methodNotAllowed();
  });

  return handler(context);
}

