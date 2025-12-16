import 'dart:async';
import 'package:mysql1/mysql1.dart';
import '../config/app_config.dart';

/// Simple connection pool for MySQL connections
/// Reuses connections to reduce overhead
class ConnectionPool {
  static final ConnectionPool _instance = ConnectionPool._internal();
  factory ConnectionPool() => _instance;
  ConnectionPool._internal();

  final List<MySqlConnection> _availableConnections = [];
  final List<MySqlConnection> _inUseConnections = [];
  final int _maxPoolSize = 10;
  final int _minPoolSize = 2;
  
  Timer? _cleanupTimer;
  bool _isInitialized = false;

  /// Initialize the connection pool
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    // Create minimum pool size connections
    for (int i = 0; i < _minPoolSize; i++) {
      final conn = await _createConnection();
      _availableConnections.add(conn);
    }
    
    _isInitialized = true;
    
    // Start cleanup timer to remove idle connections
    _cleanupTimer = Timer.periodic(Duration(minutes: 1), (_) => _cleanupIdleConnections());
  }

  /// Get a connection from the pool
  Future<MySqlConnection> getConnection() async {
    if (!_isInitialized) {
      await initialize();
    }

    MySqlConnection? connection;

    // Try to get an available connection
    if (_availableConnections.isNotEmpty) {
      connection = _availableConnections.removeAt(0);
    } else if (_inUseConnections.length < _maxPoolSize) {
      // Create a new connection if under max pool size
      connection = await _createConnection();
    } else {
      // Wait for a connection to become available
      connection = await _waitForConnection();
    }

    _inUseConnections.add(connection);
    return connection;
  }

  /// Return a connection to the pool
  void releaseConnection(MySqlConnection connection) {
    if (!_inUseConnections.contains(connection)) {
      return; // Connection not from this pool
    }

    _inUseConnections.remove(connection);

    // Try to return connection to pool
    // If connection is dead, it will fail on next use and be recreated
    try {
      _availableConnections.add(connection);
    } catch (e) {
      // Connection is dead, don't return it to pool
      // A new one will be created when needed
    }
  }

  /// Create a new database connection
  Future<MySqlConnection> _createConnection() async {
    final settings = ConnectionSettings(
      host: AppConfig.dbHost,
      port: AppConfig.dbPort,
      user: AppConfig.dbUser,
      password: AppConfig.dbPassword,
      db: AppConfig.dbName,
    );
    
    return await MySqlConnection.connect(settings);
  }

  /// Wait for a connection to become available
  Future<MySqlConnection> _waitForConnection() async {
    final completer = Completer<MySqlConnection>();
    final maxWaitTime = Duration(seconds: 5);
    final startTime = DateTime.now();

    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_availableConnections.isNotEmpty) {
        final conn = _availableConnections.removeAt(0);
        _inUseConnections.add(conn);
        completer.complete(conn);
        timer.cancel();
      } else if (DateTime.now().difference(startTime) > maxWaitTime) {
        // Timeout - create a new connection even if over limit
        _createConnection().then((conn) {
          _inUseConnections.add(conn);
          completer.complete(conn);
        });
        timer.cancel();
      }
    });

    return completer.future;
  }

  /// Clean up idle connections
  void _cleanupIdleConnections() {
    // Keep minimum pool size, remove excess idle connections
    while (_availableConnections.length > _minPoolSize) {
      final conn = _availableConnections.removeAt(0);
      try {
        conn.close();
      } catch (e) {
        // Connection already closed or dead, ignore
      }
    }
  }

  /// Close all connections and cleanup
  Future<void> close() async {
    _cleanupTimer?.cancel();
    
    for (final conn in _availableConnections) {
      try {
        await conn.close();
      } catch (e) {
        // Connection already closed, ignore
      }
    }
    
    for (final conn in _inUseConnections) {
      try {
        await conn.close();
      } catch (e) {
        // Connection already closed, ignore
      }
    }
    
    _availableConnections.clear();
    _inUseConnections.clear();
    _isInitialized = false;
  }

  /// Get pool statistics
  Map<String, dynamic> getStats() {
    return {
      'available': _availableConnections.length,
      'inUse': _inUseConnections.length,
      'total': _availableConnections.length + _inUseConnections.length,
      'maxPoolSize': _maxPoolSize,
      'minPoolSize': _minPoolSize,
    };
  }
}

