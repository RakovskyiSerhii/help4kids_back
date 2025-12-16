import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/article_service.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context, String articleId) async {
  // GET /api/articles/{articleId}: Retrieve article details (public)
  if (context.request.method == HttpMethod.get) {
    try {
      if (!Validation.isValidUuid(articleId)) {
        return ResponseHelpers.error(
          ApiErrors.validationError('Invalid article ID format'),
        );
      }
      final article = await ArticleService.getArticleById(articleId);
      if (article == null) {
        return ResponseHelpers.error(ApiErrors.notFound('Article'));
      }
      return ResponseHelpers.success(article.toJson());
    } catch (e) {
      return ResponseHelpers.error(
        ApiErrors.internalError('Failed to fetch article'),
      );
    }
  }
  // PUT /api/articles/{articleId}: Update an article (admin/god only)
  else if (context.request.method == HttpMethod.put) {
    final handler = requireAdmin((context) async {
      try {
        if (!Validation.isValidUuid(articleId)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Invalid article ID format'),
          );
        }
        final body = await context.request.json() as Map<String, dynamic>;
        final success = await ArticleService.updateArticle(articleId, body);
        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Update failed'),
          );
        }
        final updatedArticle = await ArticleService.getArticleById(articleId);
        if (updatedArticle == null) {
          return ResponseHelpers.error(ApiErrors.notFound('Article'));
        }
        return ResponseHelpers.success(updatedArticle.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to update article'),
        );
      }
    });
    return handler(context);
  }
  // DELETE /api/articles/{articleId}: Delete an article (admin/god only)
  else if (context.request.method == HttpMethod.delete) {
    final handler = requireAdmin((context) async {
      try {
        if (!Validation.isValidUuid(articleId)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Invalid article ID format'),
          );
        }
        final success = await ArticleService.deleteArticle(articleId);
        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Deletion failed'),
          );
        }
        return ResponseHelpers.success({'message': 'Article deleted successfully'});
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to delete article'),
        );
      }
    });
    return handler(context);
  }
  return ResponseHelpers.methodNotAllowed();
}