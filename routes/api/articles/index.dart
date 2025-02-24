import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/article_service.dart';

Future<Response> onRequest(RequestContext context) async {
  // GET /api/articles: List all articles (public)
  if (context.request.method == HttpMethod.get) {
    final articles = await ArticleService.getAllArticles();
    return Response.json(
      body: {'articles': articles.map((a) => a.toJson()).toList()},
    );
  }
  // POST /api/articles: Create a new article (admin/god only)
  else if (context.request.method == HttpMethod.post) {
    // Check role (only 'admin' or 'god' allowed)
    final role = context.request.headers['x-role'] ?? 'customer';
    if (role != 'admin' && role != 'god') {
      return Response.json(
        body: {'error': 'Unauthorized'},
        statusCode: 403,
      );
    }
    final body = await context.request.json();

    final title = body['title'] as String?;
    final content = body['content'] as String?;
    final categoryId = body['categoryId'] as String?;

    if (title == null || content == null || categoryId == null) {
      return Response.json(
        body: {'error': 'Missing required fields: title, content, categoryId'},
        statusCode: 400,
      );
    }
    // Optional audit fields can be set within the service.
    final article = await ArticleService.createArticle(
      title: title,
      content: content,
      categoryId: categoryId,
      // Optionally pass longDescription if provided:
      longDescription: body['longDescription'] as String?,
    );
    return Response.json(body: article.toJson());
  }
  return Response(statusCode: 405);
}