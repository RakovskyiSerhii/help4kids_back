import 'package:uuid/uuid.dart';
import '../data/mysql_connection.dart';
import '../models/course.dart';

class CourseService {
  static Future<List<Course>> getAllCourses() async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query('SELECT * FROM courses');
      return results.map((row) {
        final fields = row.fields;
        return Course(
          id: fields['id']?.toString() ?? '',
          title: fields['title']?.toString() ?? '',
          shortDescription: fields['short_description']?.toString() ?? '',
          longDescription: fields['long_description']?.toString(),
          image: fields['image']?.toString(),
          icon: fields['icon']?.toString() ?? '',
          price: double.tryParse(fields['price']?.toString() ?? '0.0') ?? 0.0,
          duration: int.tryParse(fields['duration']?.toString() ?? ''),
          contentUrl: fields['content_url']?.toString() ?? '',
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

  static Future<Course?> getCourseById(String courseId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query(
        "SELECT * FROM courses WHERE id = '$courseId'",
      );
      if (results.isEmpty) return null;
      final fields = results.first.fields;
      return Course(
        id: fields['id']?.toString() ?? '',
        title: fields['title']?.toString() ?? '',
        shortDescription: fields['short_description']?.toString() ?? '',
        longDescription: fields['long_description']?.toString(),
        image: fields['image']?.toString(),
        icon: fields['icon']?.toString() ?? '',
        price: double.tryParse(fields['price']?.toString() ?? '0.0') ?? 0.0,
        duration: int.tryParse(fields['duration']?.toString() ?? ''),
        contentUrl: fields['content_url']?.toString() ?? '',
        createdAt: DateTime.parse(fields['created_at'].toString()),
        updatedAt: DateTime.parse(fields['updated_at'].toString()),
        createdBy: fields['created_by']?.toString(),
        updatedBy: fields['updated_by']?.toString(),
      );
    } finally {
      await conn.close();
    }
  }

  static Future<Course> createCourse({
    required String title,
    required String shortDescription,
    String? longDescription,
    String? image,
    required String icon,
    required double price,
    int? duration,
    required String contentUrl,
  }) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final courseId = Uuid().v4();
      await conn.query(
        '''
        INSERT INTO courses 
          (id, title, short_description, long_description, image, icon, price, duration, content_url, created_at, updated_at)
        VALUES ('$courseId', '$title', '$shortDescription', '$longDescription', '$image', '$icon', $price, $duration, '$contentUrl', NOW(), NOW())
        ''',
      );
      return Course(
        id: courseId,
        title: title,
        shortDescription: shortDescription,
        longDescription: longDescription,
        image: image,
        icon: icon,
        price: price,
        duration: duration,
        contentUrl: contentUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy: null,
        updatedBy: null,
      );
    } finally {
      await conn.close();
    }
  }

  static Future<bool> updateCourse(String courseId, Map<String, dynamic> body) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final fields = <String>[];

      if (body.containsKey('title')) {
        fields.add("title = '${body['title']}'");
      }
      if (body.containsKey('shortDescription')) {
        fields.add("short_description = '${body['shortDescription']}'");
      }
      if (body.containsKey('longDescription')) {
        fields.add("long_description = '${body['longDescription']}'");
      }
      if (body.containsKey('image')) {
        fields.add("image = '${body['image']}'");
      }
      if (body.containsKey('icon')) {
        fields.add("icon = '${body['icon']}'");
      }
      if (body.containsKey('price')) {
        fields.add("price = ${body['price']}");
      }
      if (body.containsKey('duration')) {
        fields.add("duration = ${body['duration']}");
      }
      if (body.containsKey('contentUrl')) {
        fields.add("content_url = '${body['contentUrl']}'");
      }

      if (fields.isEmpty) return false;
      final query = "UPDATE courses SET ${fields.join(", ")}, updated_at = NOW() WHERE id = '$courseId'";
      final result = await conn.query(query);
      return result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  static Future<bool> deleteCourse(String courseId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final result = await conn.query(
        "DELETE FROM courses WHERE id = '$courseId'",
      );
      return result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  static Future<List<Course>> getPurchasedCourses(String userId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query(
        '''
        SELECT c.* FROM courses c
        JOIN orders o ON c.id = o.service_id
        WHERE o.user_id = '$userId' AND o.service_type = 'course' AND o.status = 'paid'
        ''',
      );
      return results.map((row) {
        final fields = row.fields;
        return Course(
          id: fields['id']?.toString() ?? '',
          title: fields['title']?.toString() ?? '',
          shortDescription: fields['short_description']?.toString() ?? '',
          longDescription: fields['long_description']?.toString(),
          image: fields['image']?.toString(),
          icon: fields['icon']?.toString() ?? '',
          price: double.tryParse(fields['price']?.toString() ?? '0.0') ?? 0.0,
          duration: int.tryParse(fields['duration']?.toString() ?? ''),
          contentUrl: fields['content_url']?.toString() ?? '',
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
}