import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/auth_service.dart';
import 'package:help4kids/middleware/auth_middleware.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/response_helpers.dart';

import 'package:help4kids/services/user_service.dart';
import 'package:help4kids/utils/validation.dart';

Future<Response> onRequest(RequestContext context) async {
  // Apply auth middleware
  final handler = authMiddleware((context) async {
    if (context.request.method == HttpMethod.get) {
      try {
        // Get userId from context (set by auth middleware)
        final payload = context.read<JwtPayload>();
        final userId = payload.id;
        final user = await AuthService.getUserProfile(userId);
        if (user == null) {
          return ResponseHelpers.error(ApiErrors.notFound('User'));
        }
        // Don't expose password hash
        final userJson = user.toJson();
        userJson.remove('passwordHash');
        return ResponseHelpers.success(userJson);
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to fetch user profile'),
        );
      }
    }
    
    // PUT /api/auth/me: Update own profile
    if (context.request.method == HttpMethod.put) {
      try {
        final payload = context.read<JwtPayload>();
        final userId = payload.id;
        final body = await context.request.json() as Map<String, dynamic>;
        
        // Validate allowed fields for profile update
        final allowedFields = ['firstName', 'lastName', 'phone'];
        final updateData = <String, dynamic>{};
        
        for (final field in allowedFields) {
          if (body.containsKey(field)) {
            final value = body[field];
            if (value != null) {
              // Validate phone number format if provided
              if (field == 'phone' && value is String && value.isNotEmpty) {
                // Basic phone validation - can be enhanced
                if (value.length > 50) {
                  return ResponseHelpers.error(
                    ApiErrors.validationError('Phone number is too long (max 50 characters)'),
                  );
                }
              }
              // Validate name fields
              if ((field == 'firstName' || field == 'lastName') && value is String) {
                if (value.trim().isEmpty) {
                  return ResponseHelpers.error(
                    ApiErrors.validationError('$field cannot be empty'),
                  );
                }
                if (value.length > 100) {
                  return ResponseHelpers.error(
                    ApiErrors.validationError('$field is too long (max 100 characters)'),
                  );
                }
              }
              updateData[field] = value;
            }
          }
        }
        
        if (updateData.isEmpty) {
          return ResponseHelpers.error(
            ApiErrors.validationError('No valid fields to update'),
          );
        }
        
        final success = await UserService.updateUser(userId, updateData);
        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Failed to update profile'),
          );
        }
        
        // Return updated user
        final updatedUser = await AuthService.getUserProfile(userId);
        if (updatedUser == null) {
          return ResponseHelpers.error(ApiErrors.notFound('User'));
        }
        final userJson = updatedUser.toJson();
        userJson.remove('passwordHash');
        return ResponseHelpers.success(userJson);
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to update profile'),
        );
      }
    }
    
    return ResponseHelpers.methodNotAllowed();
  });

  return handler(context);
}