/// Standardized error responses for the API
class ApiError {
  final String message;
  final int statusCode;
  final String? code;

  ApiError({
    required this.message,
    required this.statusCode,
    this.code,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'error': message,
    };
    if (code != null) {
      json['code'] = code!;
    }
    return json;
  }
}

/// Common API error codes
class ErrorCodes {
  static const String validationError = 'VALIDATION_ERROR';
  static const String notFound = 'NOT_FOUND';
  static const String unauthorized = 'UNAUTHORIZED';
  static const String forbidden = 'FORBIDDEN';
  static const String conflict = 'CONFLICT';
  static const String internalError = 'INTERNAL_ERROR';
  static const String badRequest = 'BAD_REQUEST';
}

/// Common API errors
class ApiErrors {
  static ApiError notFound(String resource) => ApiError(
        message: '$resource not found',
        statusCode: 404,
        code: ErrorCodes.notFound,
      );

  static ApiError unauthorized([String? message]) => ApiError(
        message: message ?? 'Unauthorized',
        statusCode: 401,
        code: ErrorCodes.unauthorized,
      );

  static ApiError forbidden([String? message]) => ApiError(
        message: message ?? 'Insufficient permissions',
        statusCode: 403,
        code: ErrorCodes.forbidden,
      );

  static ApiError validationError(String message) => ApiError(
        message: message,
        statusCode: 400,
        code: ErrorCodes.validationError,
      );

  static ApiError conflict(String message) => ApiError(
        message: message,
        statusCode: 409,
        code: ErrorCodes.conflict,
      );

  static ApiError badRequest(String message) => ApiError(
        message: message,
        statusCode: 400,
        code: ErrorCodes.badRequest,
      );

  static ApiError internalError([String? message]) => ApiError(
        message: message ?? 'An internal error occurred',
        statusCode: 500,
        code: ErrorCodes.internalError,
      );
}

