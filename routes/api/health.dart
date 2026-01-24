import 'package:dart_frog/dart_frog.dart';
import '../../lib/data/connection_pool.dart';
import '../../lib/utils/response_helpers.dart';

/// Health check endpoint for load balancers
/// Returns 200 if healthy, 503 if unhealthy
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.get) {
    try {
      // Quick database connection check
      final pool = ConnectionPool();
      final stats = pool.getStats();
      
      // Try to get a connection (but don't hold it)
      final conn = await pool.getConnection();
      try {
        // Simple query to verify database connectivity
        await conn.query('SELECT 1');
      } finally {
        pool.releaseConnection(conn);
      }
      
      return Response.json(
        body: {
          'status': 'healthy',
          'timestamp': DateTime.now().toIso8601String(),
          'pool': stats,
        },
      );
    } catch (e) {
      // Return 503 (Service Unavailable) if health check fails
      return Response.json(
        body: {
          'status': 'unhealthy',
          'error': e.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        },
        statusCode: 503,
      );
    }
  }
  
  return ResponseHelpers.methodNotAllowed();
}

