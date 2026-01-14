import 'package:help4kids/models/landing.dart';
import 'package:help4kids/models/service_category.dart';
import '../models/article.dart';
import '../models/consultation.dart';
import '../models/staff.dart';
import '../utils/db_helper.dart';

class LandingService {
  static Future<LandingResponse> getFeaturedContent() async {
    return await DbHelper.withConnection((conn) async {
      // Execute all queries in parallel for better performance
      final results = await Future.wait([
        conn.query("SELECT id, name, description, iconUrl FROM service_categories WHERE featured = true"),
        conn.query("SELECT id, name, content, photo_url, featured, created_at, updated_at FROM staff WHERE featured = true"),
        conn.query("SELECT id, title, short_description, price, created_at, updated_at FROM consultations"),
        conn.query("SELECT id, title, content, category_id, created_at, updated_at FROM articles"),
      ]);

      final services = results[0];
      final staff = results[1];
      final consultations = results[2];
      final articles = results[3];

      final featuredServices = services.map((row) {
        return ServiceCategory(
          id: row['id']?.toString() ?? '',
          name: row['name']?.toString() ?? '',
          iconUrl: row['iconUrl']?.toString() ?? '',
          description: row['description']?.toString() ?? '',
        );
      }).toList();

      final featuredStaff = staff.map((row) {
        return Staff(
          id: row['id'].toString(),
          name: row['name'].toString(),
          content: row['content'].toString(),
          featured: row['featured'] == 1,
          photoUrl: row['photo_url']?.toString() ?? '',
          createdAt: DateTime.parse(row['created_at'].toString()),
          updatedAt: DateTime.parse(row['updated_at'].toString()),
        );
      }).toList();

      final featuredConsultations = consultations
          .map((row) => Consultation.fromMap(row.fields))
          .toList();

      final featuredArticles = articles
          .map((row) => Article(
                id: row['id'].toString(),
                title: row['title'].toString(),
                content: row['content'].toString(),
                categoryId: row['category_id'].toString(),
                createdAt: DateTime.parse(row['created_at'].toString()),
                updatedAt: DateTime.parse(row['updated_at'].toString()),
              ))
          .toList();

      return LandingResponse(
        featuredServices: featuredServices,
        featuredStaff: featuredStaff,
        featuredConsultations: featuredConsultations,
        featuredArticles: featuredArticles,
      );
    });
  }
}
