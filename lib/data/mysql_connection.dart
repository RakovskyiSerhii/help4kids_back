import 'package:mysql1/mysql1.dart';
import '../config/app_config.dart';
import 'connection_pool.dart';

typedef MySQLConnectionFactory = Future<MySqlConnection> Function();

class MySQLConnection {
  // A mutable static field that can be overridden in tests.
  static MySQLConnectionFactory connectionFactory = _defaultConnectionFactory;
  static bool _usePool = true;
  static final ConnectionPool _pool = ConnectionPool();

  /// Enable or disable connection pooling (disabled by default for tests)
  static void setUsePool(bool usePool) {
    _usePool = usePool;
  }

  static Future<MySqlConnection> _defaultConnectionFactory() async {
    if (_usePool) {
      return await _pool.getConnection();
    }
    
    // Fallback to direct connection (for tests)
    final settings = ConnectionSettings(
      host: AppConfig.dbHost,
      port: AppConfig.dbPort,
      user: AppConfig.dbUser,
      password: AppConfig.dbPassword,
      db: AppConfig.dbName,
    );
    return MySqlConnection.connect(settings);
  }

  /// Open a connection (uses pool if enabled)
  static Future<MySqlConnection> openConnection() async => await connectionFactory();

  /// Release a connection back to the pool
  static void releaseConnection(MySqlConnection connection) {
    if (_usePool) {
      _pool.releaseConnection(connection);
    } else {
      // In test mode, just close it
      try {
        connection.close();
      } catch (e) {
        // Connection already closed, ignore
      }
    }
  }

  /// Initialize the connection pool
  static Future<void> initializePool() async {
    if (_usePool) {
      await _pool.initialize();
    }
  }

  /// Close the connection pool
  static Future<void> closePool() async {
    if (_usePool) {
      await _pool.close();
    }
  }

  /// Get pool statistics
  static Map<String, dynamic>? getPoolStats() {
    if (_usePool) {
      return _pool.getStats();
    }
    return null;
  }
}