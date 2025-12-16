import 'package:dart_frog/dart_frog.dart';

/// Simple CORS middleware to allow browser clients to call the API.
Handler corsMiddleware(Handler handler) {
  return (context) async {
    // Handle preflight requests.
    if (context.request.method == HttpMethod.options) {
      return Response(
        statusCode: 204,
        headers: _corsHeaders,
      );
    }

    final response = await handler(context);
    return response.copyWith(
      headers: {
        ...response.headers,
        ..._corsHeaders,
      },
    );
  };
}

const _corsHeaders = <String, String>{
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE, OPTIONS',
  'Access-Control-Allow-Headers':
      'Origin, Content-Type, Accept, Authorization, X-Requested-With',
};


