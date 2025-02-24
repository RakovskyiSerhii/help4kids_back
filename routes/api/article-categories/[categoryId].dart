import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/article_category_service.dart';

Future<Response> onRequest(RequestContext context, String categoryId) async {
  // GET /api/article-categories/{categoryId}: Retrieve category details (public)
  if (context.request.method == HttpMethod.get) {
    final category = await ArticleCategoryService.getArticleCategoryById(categoryId);
    if (category == null) {
      return Response.json(
        body: {'error': 'Category not found'},
        statusCode: 404,
      );
    }
    return Response.json(body: category.toJson());
  }
  // PUT /api/article-categories/{categoryId}: Update category (admin/god only)
  else if (context.request.method == HttpMethod.put) {
    final role = context.request.headers['x-role'] ?? 'customer';
    if (role != 'admin' && role != 'god') {
      return Response.json(
        body: {'error': 'Unauthorized'},
        statusCode: 403,
      );
    }
    final body = await context.request.json();
    final success = await ArticleCategoryService.updateArticleCategory(categoryId, body);
    if (!success) {
      return Response.json(
        body: {'error': 'Update failed'},
        statusCode: 400,
      );
    }
    final updatedCategory = await ArticleCategoryService.getArticleCategoryById(categoryId);
    return Response.json(body: updatedCategory?.toJson() ?? {});
  }
  // DELETE /api/article-categories/{categoryId}: Delete category (admin/god only)
  else if (context.request.method == HttpMethod.delete) {
    final role = context.request.headers['x-role'] ?? 'customer';
    if (role != 'admin' && role != 'god') {
      return Response.json(
        body: {'error': 'Unauthorized'},
        statusCode: 403,
      );
    }
    final success = await ArticleCategoryService.deleteArticleCategory(categoryId);
    if (!success) {
      return Response.json(
        body: {'error': 'Deletion failed'},
        statusCode: 400,
      );
    }
    return Response.json(body: {'message': 'Category deleted successfully'});
  }
  return Response(statusCode: 405);
}