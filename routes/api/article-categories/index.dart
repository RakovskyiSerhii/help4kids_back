import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/article_category_service.dart';

Future<Response> onRequest(RequestContext context) async {
  // GET /api/article-categories: List all categories (public)
  if (context.request.method == HttpMethod.get) {
    final categories = await ArticleCategoryService.getAllArticleCategories();
    return Response.json(
      body: {'categories': categories.map((c) => c.toJson()).toList()},
    );
  }
  // POST /api/article-categories: Create a new category (admin/god only)
  else if (context.request.method == HttpMethod.post) {
    final role = context.request.headers['x-role'] ?? 'customer';
    if (role != 'admin' && role != 'god') {
      return Response.json(
        body: {'error': 'Unauthorized'},
        statusCode: 403,
      );
    }
    final body = await context.request.json();
    final title = body['title'] as String?;
    // description is optional
    final description = body['description'] as String?;
    if (title == null) {
      return Response.json(
        body: {'error': 'Missing required field: title'},
        statusCode: 400,
      );
    }
    final category = await ArticleCategoryService.createArticleCategory(
      title: title,
      description: description,
    );
    return Response.json(body: category.toJson());
  }
  return Response(statusCode: 405);
}