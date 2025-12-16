import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/middleware/auth_middleware.dart';
import 'package:help4kids/constants/roles.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/response_helpers.dart';

/// Helper to check if user has admin or god role
bool isAdminOrGod(JwtPayload payload) {
  return Roles.isAdmin(payload.roleId);
}

/// Helper to check if user has god role
bool isGod(JwtPayload payload) {
  return Roles.isGod(payload.roleId);
}

/// Wrapper to apply auth middleware and check for admin/god role
Handler requireAdmin(Handler handler) {
  return authMiddleware((context) async {
    try {
      final payload = context.read<JwtPayload>();
      if (!isAdminOrGod(payload)) {
        return ResponseHelpers.error(ApiErrors.forbidden());
      }
      return handler(context);
    } catch (e) {
      return ResponseHelpers.error(ApiErrors.unauthorized());
    }
  });
}

/// Wrapper to apply auth middleware and check for god role
Handler requireGod(Handler handler) {
  return authMiddleware((context) async {
    try {
      final payload = context.read<JwtPayload>();
      if (!isGod(payload)) {
        return ResponseHelpers.error(ApiErrors.forbidden());
      }
      return handler(context);
    } catch (e) {
      return ResponseHelpers.error(ApiErrors.unauthorized());
    }
  });
}

