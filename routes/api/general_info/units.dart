import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/data/mysql_connection.dart';
import 'package:help4kids/models/unit.dart';
import 'package:uuid/uuid.dart';

Future<Response> onRequest(RequestContext context) async {
  // TODO: Add admin/god authorization check.
  final conn = await MySQLConnection.openConnection();
  try {
    if (context.request.method == HttpMethod.get) {
      // List units
      final results = await conn.query("SELECT * FROM unit");
      final units = results.map((row) => Unit.fromRow(row.fields)).toList();
      return Response.json(body: {'units': units.map((e) => e.toJson()).toList()});
    } else if (context.request.method == HttpMethod.put) {
      // Bulk update units
      final body = await context.request.json() as Map<String, dynamic>;
      final units = body['units'] as List<dynamic>? ?? [];
      final uuid = Uuid();
      await conn.query("DELETE FROM unit");
      for (final u in units) {
        final id = (u['id']?.toString().isNotEmpty ?? false) ? u['id'] : uuid.v4();
        final address = u['address'] ?? '';
        final workingTime = u['workingTime'] ?? '';
        final contactPhone = u['contactPhone'] ?? '';
        final socialUrl = u['socialUrl'] ?? '';
        await conn.query(
            "INSERT INTO unit (id, address, working_time, contact_phone, social_url, created_at, updated_at) "
                "VALUES ('$id', '$address', '$workingTime', '$contactPhone', '$socialUrl', NOW(), NOW())"
        );
      }
      return Response.json(body: {'message': 'Units updated successfully'});
    } else {
      return Response(statusCode: 405);
    }
  } catch (e) {
    return Response.json(body: {'error': e.toString()}, statusCode: 500);
  } finally {
    await conn.close();
  }
}