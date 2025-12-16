import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/article_category_service.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context, String categoryId) async {
  // GET /api/article-categories/{categoryId}: Retrieve category details (public)
  if (context.request.method == HttpMethod.get) {
    try {
      if (!Validation.isValidUuid(categoryId)) {
        return ResponseHelpers.error(
          ApiErrors.validationError('Invalid category ID format'),
        );
      }
      final category = await ArticleCategoryService.getArticleCategoryById(categoryId);
      if (category == null) {
        return ResponseHelpers.error(ApiErrors.notFound('Category'));
      }
      return ResponseHelpers.success(category.toJson());
    } catch (e) {
      return ResponseHelpers.error(
        ApiErrors.internalError('Failed to fetch category'),
      );
    }
  }
  // PUT /api/article-categories/{categoryId}: Update category (admin/god only)
  else if (context.request.method == HttpMethod.put) {
    final handler = requireAdmin((context) async {
      try {
        if (!Validation.isValidUuid(categoryId)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Invalid category ID format'),
          );
        }
        final body = await context.request.json() as Map<String, dynamic>;
        final success = await ArticleCategoryService.updateArticleCategory(categoryId, body);
        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Update failed'),
          );
        }
        final updatedCategory = await ArticleCategoryService.getArticleCategoryById(categoryId);
        if (updatedCategory == null) {
          return ResponseHelpers.error(ApiErrors.notFound('Category'));
        }
        return ResponseHelpers.success(updatedCategory.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to update category'),
        );
      }
    });
    return handler(context);
  }
  // DELETE /api/article-categories/{categoryId}: Delete category (admin/god only)
  else if (context.request.method == HttpMethod.delete) {
    final handler = requireAdmin((context) async {
      try {
        if (!Validation.isValidUuid(categoryId)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Invalid category ID format'),
          );
        }
        final success = await ArticleCategoryService.deleteArticleCategory(categoryId);
        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Deletion failed'),
          );
        }
        return ResponseHelpers.success({'message': 'Category deleted successfully'});
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to delete category'),
        );
      }
    });
    return handler(context);
  }
  return ResponseHelpers.methodNotAllowed();
}