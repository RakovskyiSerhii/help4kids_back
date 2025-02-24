import 'package:uuid/uuid.dart';
import '../data/mysql_connection.dart';
import '../models/service.dart';

class ServiceService {
  // Retrieve all services
  static Future<List<Service>> getAllServices() async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query('SELECT * FROM services');
      return results.map((row) {
        final fields = row.fields;
        return Service(
          id: fields['id']?.toString() ?? '',
          title: fields['title']?.toString() ?? '',
          shortDescription: fields['short_description']?.toString() ?? '',
          longDescription: fields['long_description']?.toString(),
          image: fields['image']?.toString(),
          icon: fields['icon']?.toString() ?? '',
          price: double.tryParse(fields['price']?.toString() ?? '0.0') ?? 0.0,
          duration: int.tryParse(fields['duration']?.toString() ?? '0'),
          categoryId: fields['category_id']?.toString() ?? '',
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

  // Retrieve a specific service by its ID
  static Future<Service?> getServiceById(String serviceId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query(
        "SELECT * FROM services WHERE id = '$serviceId'",
      );
      if (results.isEmpty) return null;
      final fields = results.first.fields;
      return Service(
        id: fields['id']?.toString() ?? '',
        title: fields['title']?.toString() ?? '',
        shortDescription: fields['short_description']?.toString() ?? '',
        longDescription: fields['long_description']?.toString(),
        image: fields['image']?.toString(),
        icon: fields['icon']?.toString() ?? '',
        price: double.tryParse(fields['price']?.toString() ?? '0.0') ?? 0.0,
        duration: int.tryParse(fields['duration']?.toString() ?? '0'),
        categoryId: fields['category_id']?.toString() ?? '',
        createdAt: DateTime.parse(fields['created_at'].toString()),
        updatedAt: DateTime.parse(fields['updated_at'].toString()),
        createdBy: fields['created_by']?.toString(),
        updatedBy: fields['updated_by']?.toString(),
      );
    } finally {
      await conn.close();
    }
  }

  // Create a new service record
  static Future<Service> createService({
    required String title,
    required String shortDescription,
    String? longDescription,
    String? image,
    required String icon,
    required double price,
    int? duration,
    required String categoryId,
  }) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final serviceId = Uuid().v4();
      await conn.query(
        '''
        INSERT INTO services 
          (id, title, short_description, long_description, image, icon, price, duration, category_id, created_at, updated_at)
        VALUES ('$serviceId', '$title', '$shortDescription', '$longDescription', '$image', '$icon', $price, $duration, '$categoryId', NOW(), NOW())
        ''',
      );
      return Service(
        id: serviceId,
        title: title,
        shortDescription: shortDescription,
        longDescription: longDescription,
        image: image,
        icon: icon,
        price: price,
        duration: duration,
        categoryId: categoryId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy: null,
        updatedBy: null,
      );
    } finally {
      await conn.close();
    }
  }

  // Update an existing service record
  static Future<bool> updateService(String serviceId, Map<String, dynamic> body) async {
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
      if (body.containsKey('categoryId')) {
        fields.add("category_id = '${body['categoryId']}'");
      }
      if (fields.isEmpty) return false;

      final query = "UPDATE services SET ${fields.join(", ")}, updated_at = NOW() WHERE id = '$serviceId'";
      final result = await conn.query(query);
      return result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  // Delete a service record
  static Future<bool> deleteService(String serviceId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final result = await conn.query("DELETE FROM services WHERE id = '$serviceId'");
      return result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }
}