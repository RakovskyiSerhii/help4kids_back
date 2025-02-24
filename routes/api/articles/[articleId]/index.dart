import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/article_service.dart';

Future<Response> onRequest(RequestContext context, String articleId) async {
  // GET /api/articles/{articleId}: Retrieve article details (public)
  if (context.request.method == HttpMethod.get) {
    final article = await ArticleService.getArticleById(articleId);
    if (article == null) {
      return Response.json(
        body: {'error': 'Article not found'},
        statusCode: 404,
      );
    }
    return Response.json(body: article.toJson());
  }
  // PUT /api/articles/{articleId}: Update an article (admin/god only)
  else if (context.request.method == HttpMethod.put) {
    final role = context.request.headers['x-role'] ?? 'customer';
    if (role != 'admin' && role != 'god') {
      return Response.json(
        body: {'error': 'Unauthorized'},
        statusCode: 403,
      );
    }
    final body = await context.request.json();
    final success = await ArticleService.updateArticle(articleId, body);
    if (!success) {
      return Response.json(
        body: {'error': 'Update failed'},
        statusCode: 400,
      );
    }
    final updatedArticle = await ArticleService.getArticleById(articleId);
    return Response.json(body: updatedArticle?.toJson() ?? {});
  }
  // DELETE /api/articles/{articleId}: Delete an article (admin/god only)
  else if (context.request.method == HttpMethod.delete) {
    final role = context.request.headers['x-role'] ?? 'customer';
    if (role != 'admin' && role != 'god') {
      return Response.json(
        body: {'error': 'Unauthorized'},
        statusCode: 403,
      );
    }
    final success = await ArticleService.deleteArticle(articleId);
    if (!success) {
      return Response.json(
        body: {'error': 'Deletion failed'},
        statusCode: 400,
      );
    }
    return Response.json(body: {'message': 'Article deleted successfully'});
  }
  return Response(statusCode: 405);
}