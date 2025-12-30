import 'dart:io';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String iconName) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    // Get the project root directory
    final currentDir = Directory.current;
    final iconPath = '${currentDir.path}/assets/icons/$iconName';

    final iconFile = File(iconPath);
    
    if (!await iconFile.exists()) {
      return Response(
        statusCode: HttpStatus.notFound,
        body: 'Icon not found: $iconName',
      );
    }

    final iconContent = await iconFile.readAsString();
    
    return Response(
      headers: {
        'Content-Type': 'image/svg+xml',
        'Cache-Control': 'public, max-age=31536000', // Cache for 1 year
      },
      body: iconContent,
    );
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: 'Error serving icon: $e',
    );
  }
}

