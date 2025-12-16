import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/article_category_service.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context) async {
  // GET /api/article-categories: List all categories (public)
  if (context.request.method == HttpMethod.get) {
    try {
      final categories = await ArticleCategoryService.getAllArticleCategories();
      return ResponseHelpers.success(
        {'categories': categories.map((c) => c.toJson()).toList()},
      );
    } catch (e) {
      return ResponseHelpers.error(
        ApiErrors.internalError('Failed to fetch categories'),
      );
    }
  }
  // POST /api/article-categories: Create a new category (admin/god only)
  else if (context.request.method == HttpMethod.post) {
    final handler = requireAdmin((context) async {
      try {
        final body = await context.request.json() as Map<String, dynamic>;
        final title = body['title'] as String?;
        final description = body['description'] as String?;

        if (title == null) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Missing required field: title'),
          );
        }

        if (!Validation.isNotEmpty(title)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Title cannot be empty'),
          );
        }

        final category = await ArticleCategoryService.createArticleCategory(
          title: title.trim(),
          description: description?.trim(),
        );
        return ResponseHelpers.success(category.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to create category'),
        );
      }
    });

    return handler(context);
  }
  return ResponseHelpers.methodNotAllowed();
}