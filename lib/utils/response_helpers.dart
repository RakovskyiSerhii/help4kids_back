import 'package:dart_frog/dart_frog.dart';
import 'errors.dart';

/// Helper functions for creating standardized API responses
class ResponseHelpers {
  /// Create an error response
  static Response error(ApiError error) {
    return Response.json(
      body: error.toJson(),
      statusCode: error.statusCode,
    );
  }

  /// Create a success response with data
  static Response success(Map<String, dynamic> data, {int statusCode = 200}) {
    return Response.json(
      body: data,
      statusCode: statusCode,
    );
  }

  /// Create a method not allowed response
  static Response methodNotAllowed() {
    return Response(
      statusCode: 405,
      body: 'Method not allowed',
    );
  }
}

