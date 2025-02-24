import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/article_service.dart';

Future<Response> onRequest(RequestContext context, String articleId) async {
  // POST /api/articles/{articleId}/save: Save (bookmark) an article for the user
  if (context.request.method == HttpMethod.post) {
    // In production, obtain authenticated user's ID from middleware
    final userId = context.request.headers['x-user-id'] ?? 'simulated-user-id';
    final success = await ArticleService.saveArticle(userId, articleId);
    if (success) {
      return Response.json(body: {'message': 'Article saved successfully'});
    } else {
      return Response.json(
        body: {'error': 'Failed to save article'},
        statusCode: 400,
      );
    }
  }
  return Response(statusCode: 405);
}