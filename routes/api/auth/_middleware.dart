import 'package:dart_frog/dart_frog.dart';
import '../../../lib/middleware/auth_middleware.dart';

Handler middleware(Handler handler) {
  // Apply auth middleware to all routes in this directory
  // Public routes (login, register, verify_email, resend_email) are handled in auth_middleware
  return authMiddleware(handler);
}

