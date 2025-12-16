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
        'SELECT * FROM courses WHERE id = ?',
        [courseId],
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
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())
        ''',
        [courseId, title, shortDescription, longDescription, image, icon, price, duration, contentUrl],
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
      final updates = <String>[];
      final params = <Object?>[];

      if (body.containsKey('title')) {
        updates.add('title = ?');
        params.add(body['title']);
      }
      if (body.containsKey('shortDescription')) {
        updates.add('short_description = ?');
        params.add(body['shortDescription']);
      }
      if (body.containsKey('longDescription')) {
        updates.add('long_description = ?');
        params.add(body['longDescription']);
      }
      if (body.containsKey('image')) {
        updates.add('image = ?');
        params.add(body['image']);
      }
      if (body.containsKey('icon')) {
        updates.add('icon = ?');
        params.add(body['icon']);
      }
      if (body.containsKey('price')) {
        updates.add('price = ?');
        params.add(body['price']);
      }
      if (body.containsKey('duration')) {
        updates.add('duration = ?');
        params.add(body['duration']);
      }
      if (body.containsKey('contentUrl')) {
        updates.add('content_url = ?');
        params.add(body['contentUrl']);
      }

      if (updates.isEmpty) return false;
      updates.add('updated_at = NOW()');
      params.add(courseId); // For WHERE clause
      final query = 'UPDATE courses SET ${updates.join(", ")} WHERE id = ?';
      final result = await conn.query(query, params);
      return result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  static Future<bool> deleteCourse(String courseId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final result = await conn.query(
        'DELETE FROM courses WHERE id = ?',
        [courseId],
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
        WHERE o.user_id = ? AND o.service_type = 'course' AND o.status = 'paid'
        ''',
        [userId],
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