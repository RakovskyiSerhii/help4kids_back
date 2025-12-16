import 'package:dart_frog/dart_frog.dart';
import '../data/mysql_connection.dart';

bool _poolInitialized = false;

/// Middleware to initialize connection pool on server start
/// This ensures the pool is ready before handling requests
Handler dbPoolMiddleware(Handler handler) {
  return handler.use(_provider());
}

Middleware _provider() {
  return (handler) {
    return (context) async {
      // Initialize pool once on first request
      if (!_poolInitialized) {
        await MySQLConnection.initializePool();
        _poolInitialized = true;
      }
      return handler(context);
    };
  };
}

