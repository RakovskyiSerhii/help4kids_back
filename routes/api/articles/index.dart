import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/article_service.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context) async {
  // GET /api/articles: List all articles (public)
  if (context.request.method == HttpMethod.get) {
    try {
      final articles = await ArticleService.getAllArticles();
      return ResponseHelpers.success(
        {'articles': articles.map((a) => a.toJson()).toList()},
      );
    } catch (e) {
      return ResponseHelpers.error(
        ApiErrors.internalError('Failed to fetch articles'),
      );
    }
  }
  // POST /api/articles: Create a new article (admin/god only)
  else if (context.request.method == HttpMethod.post) {
    // Apply auth middleware and require admin/god role
    final handler = requireAdmin((context) async {
      try {
        final body = await context.request.json() as Map<String, dynamic>;

        final title = body['title'] as String?;
        final content = body['content'] as String?;
        final categoryId = body['categoryId'] as String?;

        if (title == null || content == null || categoryId == null) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Missing required fields: title, content, categoryId'),
          );
        }

        // Enhanced validation per frontend requirements
        if (title.trim().length < 3 || title.trim().length > 200) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Title must be between 3 and 200 characters'),
          );
        }

        if (content.trim().length < 50) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Content must be at least 50 characters'),
          );
        }

        if (!Validation.isValidUuid(categoryId)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Invalid category ID format'),
          );
        }

        final article = await ArticleService.createArticle(
          title: title.trim(),
          content: content.trim(),
          categoryId: categoryId,
          longDescription: (body['longDescription'] as String?)?.trim(),
        );
        return ResponseHelpers.success(article.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to create article'),
        );
      }
    });

    return handler(context);
  }
  return ResponseHelpers.methodNotAllowed();
}