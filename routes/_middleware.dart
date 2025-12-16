import 'package:dart_frog/dart_frog.dart';
import '../lib/middleware/cors_middleware.dart';
import '../lib/middleware/db_pool_middleware.dart';

Handler middleware(Handler handler) {
  return handler
      // CORS for browser / cross-origin calls.
      .use(corsMiddleware)
      // Initialize database connection pool.
      .use(dbPoolMiddleware);
}

