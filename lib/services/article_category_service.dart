import 'package:uuid/uuid.dart';
import '../data/mysql_connection.dart';
import '../models/article_category.dart';

class ArticleCategoryService {
  /// Retrieves all article categories.
  static Future<List<ArticleCategory>> getAllArticleCategories() async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query('SELECT * FROM article_categories');
      return results.map((row) {
        final fields = row.fields;
        return ArticleCategory(
          id: fields['id']?.toString() ?? '',
          title: fields['title']?.toString() ?? '',
          description: fields['description']?.toString(),
        );
      }).toList();
    } finally {
      await conn.close();
    }
  }

  /// Retrieves a specific article category by ID.
  static Future<ArticleCategory?> getArticleCategoryById(String categoryId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query("SELECT * FROM article_categories WHERE id = '$categoryId'");
      if (results.isEmpty) return null;
      final fields = results.first.fields;
      return ArticleCategory(
        id: fields['id']?.toString() ?? '',
        title: fields['title']?.toString() ?? '',
        description: fields['description']?.toString(),
      );
    } finally {
      await conn.close();
    }
  }

  /// Creates a new article category.
  static Future<ArticleCategory> createArticleCategory({
    required String title,
    String? description,
  }) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final categoryId = Uuid().v4();
      // Use interpolation. For null description, we insert NULL without quotes.
      final descValue = description == null ? 'NULL' : "'$description'";
      await conn.query(
          "INSERT INTO article_categories (id, title, description) VALUES ('$categoryId', '$title', $descValue)"
      );
      return ArticleCategory(
        id: categoryId,
        title: title,
        description: description,
      );
    } finally {
      await conn.close();
    }
  }

  /// Updates an existing article category.
  static Future<bool> updateArticleCategory(String categoryId, Map<String, dynamic> body) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final updates = <String>[];

      if (body.containsKey('title')) {
        final title = body['title'].toString();
        updates.add("title = '$title'");
      }
      if (body.containsKey('description')) {
        final desc = body['description'] != null ? "'${body['description']}'" : 'NULL';
        updates.add("description = $desc");
      }

      if (updates.isEmpty) return false;

      final query = "UPDATE article_categories SET ${updates.join(', ')} WHERE id = '$categoryId'";
      final result = await conn.query(query);
      return result.affectedRows != null && result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  /// Deletes an article category.
  static Future<bool> deleteArticleCategory(String categoryId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final result = await conn.query("DELETE FROM article_categories WHERE id = '$categoryId'");
      return result.affectedRows != null && result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }
}