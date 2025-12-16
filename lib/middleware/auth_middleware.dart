import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import '../config/app_config.dart';

/// JWT payload structure
class JwtPayload {
  final String id;
  final String email;
  final String roleId;

  JwtPayload({
    required this.id,
    required this.email,
    required this.roleId,
  });

  factory JwtPayload.fromMap(Map<String, dynamic> map) {
    return JwtPayload(
      id: map['id'] as String,
      email: map['email'] as String,
      roleId: map['roleId'] as String,
    );
  }
}

/// Middleware to verify JWT token from Authorization header
Handler authMiddleware(Handler handler) {
  return (context) async {
    // Skip auth for public endpoints
    final path = context.request.url.path;
    final publicPaths = [
      '/api/auth/login',
      '/api/auth/register',
      '/api/auth/verify_email',
      '/api/auth/resend_email',
    ];

    if (publicPaths.contains(path)) {
      return handler(context);
    }

    // Extract token from Authorization header
    final authHeader = context.request.headers['Authorization'] ?? 
                      context.request.headers['authorization'];
    
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return Response.json(
        body: {'error': 'Missing or invalid Authorization header'},
        statusCode: 401,
      );
    }

    final token = authHeader.substring(7);

    try {
      // Verify and decode JWT
      final jwt = JWT.verify(
        token,
        SecretKey(AppConfig.jwtSecret),
        issuer: AppConfig.jwtIssuer,
      );

      // Extract payload
      final payload = JwtPayload.fromMap(jwt.payload as Map<String, dynamic>);

      // Provide user info to context
      context = context.provide<JwtPayload>(() => payload);

      return handler(context);
    } on JWTExpiredException {
      return Response.json(
        body: {'error': 'Token has expired'},
        statusCode: 401,
      );
    } on JWTException catch (e) {
      return Response.json(
        body: {'error': 'Invalid token: ${e.message}'},
        statusCode: 401,
      );
    } catch (e) {
      return Response.json(
        body: {'error': 'Authentication failed: ${e.toString()}'},
        statusCode: 401,
      );
    }
  };
}

/// Middleware to check if user has required role
/// Note: This checks roleId from JWT. In production, you should fetch role name from database
Handler Function(Handler) requireRole(List<String> allowedRoles) {
  return (Handler handler) {
    return (context) async {
      try {
        final payload = context.read<JwtPayload>();
        final roleId = payload.roleId;
        
        // Check if roleId is in allowed roles
        // TODO: In production, fetch role name from database using roleId
        if (!allowedRoles.contains(roleId)) {
          return Response.json(
            body: {'error': 'Insufficient permissions', 'code': 'FORBIDDEN'},
            statusCode: 403,
          );
        }

        return handler(context);
      } catch (e) {
        // If JwtPayload is not in context, user is not authenticated
        return Response.json(
          body: {'error': 'Authentication required', 'code': 'UNAUTHORIZED'},
          statusCode: 401,
        );
      }
    };
  };
}

