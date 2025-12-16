import 'package:dart_frog/dart_frog.dart';
import '../lib/middleware/db_pool_middleware.dart';

Handler middleware(Handler handler) {
  // Initialize database connection pool
  return handler.use(dbPoolMiddleware);
}

