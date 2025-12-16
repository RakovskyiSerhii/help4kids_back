import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/data/mysql_connection.dart';
import 'package:help4kids/models/finance_info.dart';
import 'package:uuid/uuid.dart';

Future<Response> onRequest(RequestContext context) async {
  // TODO: Add admin/god authorization check.
  final conn = await MySQLConnection.openConnection();
  try {
    if (context.request.method == HttpMethod.get) {
      final results = await conn.query("SELECT * FROM finance_info");
      final financeInfos = results.map((row) => FinanceInfo.fromRow(row.fields)).toList();
      return Response.json(body: {'financeInfo': financeInfos.map((e) => e.toJson()).toList()});
    } else if (context.request.method == HttpMethod.put) {
      final body = await context.request.json() as Map<String, dynamic>;
      final financeInfos = body['financeInfo'] as List<dynamic>? ?? [];
      final uuid = Uuid();
      await conn.query("DELETE FROM finance_info");
      for (final f in financeInfos) {
        final id = (f['id']?.toString().isNotEmpty ?? false) ? f['id'] : uuid.v4();
        final tNumber = f['tNumber'] ?? '';
        final officialAddress = f['officialAddress'] ?? '';
        final actualAddress = f['actualAddress'] ?? '';
        await conn.query(
            "INSERT INTO finance_info (id, t_number, official_address, actual_address, created_at, updated_at) "
                "VALUES ('$id', '$tNumber', '$officialAddress', '$actualAddress', NOW(), NOW())"
        );
      }
      return Response.json(body: {'message': 'Finance info updated successfully'});
    } else {
      return Response(statusCode: 405);
    }
  } catch (e) {
    return Response.json(body: {'error': e.toString()}, statusCode: 500);
  } finally {
    await conn.close();
  }
}