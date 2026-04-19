import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/content_service.dart';
import 'package:help4kids/models/content_material.dart';
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

    // GET /api/admin/contents/{contentId}/episodes/{episodeId}/materials - Get materials
    if (context.request.method == HttpMethod.get) {
      try {
        final materials = await ContentService.getMaterials(episodeId: episodeId);
        return ResponseHelpers.success({
          'materials': materials.map((m) => m.toJson()).toList(),
        });
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to fetch materials'),
        );
      }
    }

    // POST /api/admin/contents/{contentId}/episodes/{episodeId}/materials - Create material
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

        // Validate material type
        final materialTypeStr = body['materialType'] as String? ?? 'other';
        MaterialType materialType;
        try {
          materialType = MaterialType.values.firstWhere(
            (e) => e.name == materialTypeStr,
          );
        } catch (e) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Invalid materialType'),
          );
        }

        // Validate that either fileUrl or externalUrl is provided
        final fileUrl = body['fileUrl'] as String?;
        final externalUrl = body['externalUrl'] as String?;
        if ((fileUrl == null || fileUrl.isEmpty) &&
            (externalUrl == null || externalUrl.isEmpty)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Either fileUrl or externalUrl must be provided'),
          );
        }

        final material = await ContentService.createContentMaterial(
          episodeId: episodeId,
          materialType: materialType,
          title: title,
          description: body['description'] as String?,
          fileUrl: fileUrl,
          externalUrl: externalUrl,
          fileSizeBytes: body['fileSizeBytes'] != null
              ? (body['fileSizeBytes'] as num).toInt()
              : null,
          mimeType: body['mimeType'] as String?,
          ordering: (body['ordering'] as num?)?.toInt() ?? 0,
          createdBy: payload.id,
        );

        return ResponseHelpers.success(material.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to create material: ${e.toString()}'),
        );
      }
    }

    return ResponseHelpers.methodNotAllowed();
  });

  return handler(context);
}

