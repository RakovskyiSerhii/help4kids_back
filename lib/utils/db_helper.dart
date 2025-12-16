import 'package:mysql1/mysql1.dart';
import '../data/mysql_connection.dart';

/// Helper class for database operations with automatic connection management
class DbHelper {
  /// Execute a database operation with automatic connection management
  static Future<T> withConnection<T>(
    Future<T> Function(MySqlConnection conn) operation,
  ) async {
    final conn = await MySQLConnection.openConnection();
    try {
      return await operation(conn);
    } finally {
      MySQLConnection.releaseConnection(conn);
    }
  }

  /// Execute multiple queries in parallel using separate connections
  /// Note: Each query gets its own connection for true parallelism
  static Future<List<T>> parallelQueries<T>(
    List<Future<T> Function(MySqlConnection)> operations,
  ) async {
    // Execute all operations in parallel, each with its own connection
    final futures = operations.map((op) async {
      final conn = await MySQLConnection.openConnection();
      try {
        return await op(conn);
      } finally {
        MySQLConnection.releaseConnection(conn);
      }
    });
    return await Future.wait(futures);
  }
}
