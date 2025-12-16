import 'package:uuid/uuid.dart';
import '../data/mysql_connection.dart';
import '../models/article.dart';

class ArticleService {
  /// Retrieves all articles.
  static Future<List<Article>> getAllArticles() async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query('SELECT * FROM articles');
      return results.map((row) {
        final fields = row.fields;
        return Article(
          id: fields['id']?.toString() ?? '',
          title: fields['title']?.toString() ?? '',
          content: fields['content']?.toString() ?? '',
          categoryId: fields['category_id']?.toString() ?? '',
          // Uncomment if you want longDescription:
          // longDescription: fields['long_description']?.toString(),
          createdAt: DateTime.parse(fields['created_at'].toString()),
          updatedAt: DateTime.parse(fields['updated_at'].toString()),
          createdBy: fields['created_by']?.toString(),
          updatedBy: fields['updated_by']?.toString(),
        );
      }).toList();
    } finally {
      await conn.close();
    }
  }

  /// Retrieves a specific article by its ID.
  static Future<Article?> getArticleById(String articleId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query(
        'SELECT * FROM articles WHERE id = ?',
        [articleId],
      );
      if (results.isEmpty) return null;
      final fields = results.first.fields;
      return Article(
        id: fields['id']?.toString() ?? '',
        title: fields['title']?.toString() ?? '',
        content: fields['content']?.toString() ?? '',
        categoryId: fields['category_id']?.toString() ?? '',
        // longDescription: fields['long_description']?.toString(),
        createdAt: DateTime.parse(fields['created_at'].toString()),
        updatedAt: DateTime.parse(fields['updated_at'].toString()),
        createdBy: fields['created_by']?.toString(),
        updatedBy: fields['updated_by']?.toString(),
      );
    } finally {
      await conn.close();
    }
  }

  /// Creates a new article record.
  static Future<Article> createArticle({
    required String title,
    required String content,
    required String categoryId,
    String? longDescription,
  }) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final articleId = Uuid().v4();
      await conn.query(
        'INSERT INTO articles (id, title, content, category_id, long_description, created_at, updated_at) VALUES (?, ?, ?, ?, ?, NOW(), NOW())',
        [articleId, title, content, categoryId, longDescription],
      );
      return Article(
        id: articleId,
        title: title,
        content: content,
        categoryId: categoryId,
        // longDescription: longDescription,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy: null,
        updatedBy: null,
      );
    } finally {
      await conn.close();
    }
  }

  /// Updates an existing article record.
  static Future<bool> updateArticle(String articleId, Map<String, dynamic> body) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final updates = <String>[];
      final params = <Object?>[];

      if (body.containsKey('title')) {
        updates.add('title = ?');
        params.add(body['title']);
      }
      if (body.containsKey('content')) {
        updates.add('content = ?');
        params.add(body['content']);
      }
      if (body.containsKey('longDescription')) {
        updates.add('long_description = ?');
        params.add(body['longDescription']);
      }
      if (body.containsKey('categoryId')) {
        updates.add('category_id = ?');
        params.add(body['categoryId']);
      }
      if (updates.isEmpty) return false;

      updates.add('updated_at = NOW()');
      params.add(articleId); // For WHERE clause
      final query = 'UPDATE articles SET ${updates.join(", ")} WHERE id = ?';
      final result = await conn.query(query, params);
      return result.affectedRows != null && result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  /// Deletes an article record.
  static Future<bool> deleteArticle(String articleId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final result = await conn.query(
        'DELETE FROM articles WHERE id = ?',
        [articleId],
      );
      return result.affectedRows != null && result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  /// Saves (bookmarks) an article for a user.
  /// Assumes a table "saved_articles" with fields: id, user_id, article_id, saved_at.
  static Future<bool> saveArticle(String userId, String articleId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final saveId = Uuid().v4();
      final result = await conn.query(
        'INSERT INTO saved_articles (id, user_id, article_id, saved_at) VALUES (?, ?, ?, NOW())',
        [saveId, userId, articleId],
      );
      return result.affectedRows != null && result.affectedRows! > 0;
    } catch (e) {
      return false;
    } finally {
      await conn.close();
    }
  }
}