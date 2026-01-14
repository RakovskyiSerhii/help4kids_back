import 'package:help4kids/models/service_price.dart';
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
        return Service.fromRow(fields);
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
        'SELECT * FROM services WHERE id = ?',
        [serviceId],
      );
      if (results.isEmpty) return null;
      final fields = results.first.fields;
      return Service.fromRow(fields);
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
    required ServicePrice price,
    int? duration,
    required String categoryId,
    String? bookingId,
  }) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final serviceId = Uuid().v4();
      // Convert price to JSON string for storage
      final priceJson = price.toJson();
      await conn.query(
        '''
        INSERT INTO services 
          (id, title, short_description, long_description, image, icon, price, duration, category_id, booking_id, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())
        ''',
        [serviceId, title, shortDescription, longDescription, image, icon, priceJson, duration, categoryId, bookingId],
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
        bookingId: bookingId,
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
        // If price is a ServicePrice object, convert to JSON
        if (body['price'] is ServicePrice) {
          params.add((body['price'] as ServicePrice).toJson());
        } else {
          params.add(body['price']);
        }
      }
      if (body.containsKey('duration')) {
        updates.add('duration = ?');
        params.add(body['duration']);
      }
      if (body.containsKey('categoryId')) {
        updates.add('category_id = ?');
        params.add(body['categoryId']);
      }
      if (body.containsKey('bookingId')) {
        updates.add('booking_id = ?');
        params.add(body['bookingId']);
      }
      if (updates.isEmpty) return false;

      updates.add('updated_at = NOW()');
      params.add(serviceId); // For WHERE clause

      final query = 'UPDATE services SET ${updates.join(", ")} WHERE id = ?';
      final result = await conn.query(query, params);
      return result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  // Delete a service record
  static Future<bool> deleteService(String serviceId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final result = await conn.query(
        'DELETE FROM services WHERE id = ?',
        [serviceId],
      );
      return result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }
}