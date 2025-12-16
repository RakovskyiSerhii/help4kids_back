import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/article_service.dart';
import 'package:help4kids/middleware/auth_middleware.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context, String articleId) async {
  // Apply auth middleware
  final handler = authMiddleware((context) async {
    // POST /api/articles/{articleId}/save: Save (bookmark) an article for the user
    if (context.request.method == HttpMethod.post) {
      try {
        // Validate article ID format
        if (!Validation.isValidUuid(articleId)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Invalid article ID format'),
          );
        }

        // Get authenticated user's ID from JWT
        final payload = context.read<JwtPayload>();
        final userId = payload.id;
        final success = await ArticleService.saveArticle(userId, articleId);
        if (success) {
          return ResponseHelpers.success({'message': 'Article saved successfully'});
        } else {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Failed to save article'),
          );
        }
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to save article'),
        );
      }
    }
    return ResponseHelpers.methodNotAllowed();
  });

  return handler(context);
}