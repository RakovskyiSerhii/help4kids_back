import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/data/mysql_connection.dart';
import 'package:help4kids/models/social_contact.dart';
import 'package:uuid/uuid.dart';

Future<Response> onRequest(RequestContext context) async {
  // TODO: Add admin/god authorization check.
  final conn = await MySQLConnection.openConnection();
  try {
    if (context.request.method == HttpMethod.get) {
      final results = await conn.query("SELECT * FROM social_contacts");
      final contacts = results.map((row) => SocialContact.fromRow(row.fields)).toList();
      return Response.json(body: {'socialContacts': contacts.map((e) => e.toJson()).toList()});
    } else if (context.request.method == HttpMethod.put) {
      final body = await context.request.json() as Map<String, dynamic>;
      final contacts = body['socialContacts'] as List<dynamic>? ?? [];
      final uuid = Uuid();
      await conn.query("DELETE FROM social_contacts");
      for (final s in contacts) {
        final id = (s['id']?.toString().isNotEmpty ?? false) ? s['id'] : uuid.v4();
        final url = s['url'] ?? '';
        final name = s['name'] ?? '';
        await conn.query(
            "INSERT INTO social_contacts (id, url, name, created_at, updated_at) "
                "VALUES ('$id', '$url', '$name', NOW(), NOW())"
        );
      }
      return Response.json(body: {'message': 'Social contacts updated successfully'});
    } else {
      return Response(statusCode: 405);
    }
  } catch (e) {
    return Response.json(body: {'error': e.toString()}, statusCode: 500);
  } finally {
    await conn.close();
  }
}