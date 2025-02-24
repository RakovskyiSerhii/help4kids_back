import 'package:help4kids/data/mysql_connection.dart';
import '../models/activity_log.dart';

class ActivityLogService {
  static Future<List<ActivityLog>> getAllActivityLogs() async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query('SELECT * FROM activity_logs');
      return results.map((row) {
        return ActivityLog(
          id: row['id'].toString(),
          userId: row['user_id'].toString(),
          // Assuming the stored value for event_type matches the enum name (e.g., "registration")
          eventType: ActivityEventType.values.firstWhere(
                (e) => e.toString().split('.').last == row['event_type'],
          ),
          eventTimestamp: DateTime.parse(row['event_timestamp'].toString()),
        );
      }).toList();
    } finally {
      await conn.close();
    }
  }
}