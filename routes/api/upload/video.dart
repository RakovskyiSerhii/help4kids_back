import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/response_helpers.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

Future<Response> onRequest(RequestContext context) async {
  final handler = requireAdmin((context) async {
    if (context.request.method != HttpMethod.post) {
      return ResponseHelpers.methodNotAllowed();
    }

    try {
      final request = context.request;
      final contentType = request.headers['content-type'] ?? '';
      
      if (!contentType.startsWith('multipart/form-data')) {
        return ResponseHelpers.error(
          ApiErrors.validationError('Request must be multipart/form-data'),
        );
      }

      // Parse multipart form data
      final body = await request.body();
      final boundary = contentType.split('boundary=')[1];
      
      // For simplicity, we'll use a basic multipart parser
      // In production, consider using a proper multipart library
      final parts = _parseMultipart(body, boundary);
      
      File? videoFile;
      String? filename;
      
      for (final part in parts) {
        if (part['name'] == 'video' || part['name'] == 'file') {
          final fileData = part['data'] as List<int>?;
          if (fileData != null && fileData.isNotEmpty) {
            // Validate file type
            final contentType = part['content-type'] as String? ?? '';
            if (!contentType.startsWith('video/')) {
              return ResponseHelpers.error(
                ApiErrors.validationError('File must be a video'),
              );
            }
            
            // Validate file size (max 100MB)
            if (fileData.length > 100 * 1024 * 1024) {
              return ResponseHelpers.error(
                ApiErrors.validationError('Video size must not exceed 100MB'),
              );
            }
            
            filename = part['filename'] as String? ?? 'video';
            final ext = filename.split('.').last.toLowerCase();
            if (!['mp4', 'webm', 'mov', 'avi'].contains(ext)) {
              return ResponseHelpers.error(
                ApiErrors.validationError('Video must be mp4, webm, mov, or avi'),
              );
            }
            
            // Generate unique filename
            final uuid = Uuid().v4();
            final newFilename = '$uuid.$ext';
            
            // Save file to uploads directory
            final uploadsDir = Directory('uploads/videos');
            if (!await uploadsDir.exists()) {
              await uploadsDir.create(recursive: true);
            }
            
            final file = File('${uploadsDir.path}/$newFilename');
            await file.writeAsBytes(fileData);
            
            videoFile = file;
            break;
          }
        }
      }
      
      if (videoFile == null) {
        return ResponseHelpers.error(
          ApiErrors.validationError('No video file provided'),
        );
      }
      
      // Return the file URL (in production, this would be a CDN URL)
      final fileUrl = '/uploads/videos/${videoFile.path.split('/').last}';
      
      return ResponseHelpers.success({
        'url': fileUrl,
        'filename': filename,
        'size': videoFile.lengthSync(),
      });
    } catch (e) {
      return ResponseHelpers.error(
        ApiErrors.internalError('Failed to upload video: ${e.toString()}'),
      );
    }
  });

  return handler(context);
}

List<Map<String, dynamic>> _parseMultipart(List<int> data, String boundary) {
  // Basic multipart parser - for production, use a proper library
  final parts = <Map<String, dynamic>>[];
  final boundaryBytes = utf8.encode('--$boundary');
  final endBoundaryBytes = utf8.encode('--$boundary--');
  
  int start = 0;
  while (start < data.length) {
    final boundaryIndex = _findBytes(data, boundaryBytes, start);
    if (boundaryIndex == -1) break;
    
    final partStart = boundaryIndex + boundaryBytes.length;
    final nextBoundaryIndex = _findBytes(data, boundaryBytes, partStart);
    if (nextBoundaryIndex == -1) break;
    
    final partData = data.sublist(partStart, nextBoundaryIndex);
    final part = _parsePart(partData);
    if (part.isNotEmpty) {
      parts.add(part);
    }
    
    start = nextBoundaryIndex;
  }
  
  return parts;
}

int _findBytes(List<int> data, List<int> pattern, int start) {
  for (int i = start; i <= data.length - pattern.length; i++) {
    bool found = true;
    for (int j = 0; j < pattern.length; j++) {
      if (data[i + j] != pattern[j]) {
        found = false;
        break;
      }
    }
    if (found) return i;
  }
  return -1;
}

Map<String, dynamic> _parsePart(List<int> data) {
  final result = <String, dynamic>{};
  
  // Find header/body separator (CRLFCRLF or LFCRLF)
  int separatorIndex = -1;
  for (int i = 0; i < data.length - 3; i++) {
    if (data[i] == 13 && data[i + 1] == 10 && data[i + 2] == 13 && data[i + 3] == 10) {
      separatorIndex = i + 4;
      break;
    }
    if (data[i] == 10 && data[i + 1] == 13 && data[i + 2] == 10) {
      separatorIndex = i + 3;
      break;
    }
  }
  
  if (separatorIndex == -1) return result;
  
  // Parse headers
  final headerBytes = data.sublist(0, separatorIndex - 4);
  final headerText = utf8.decode(headerBytes);
  final headers = headerText.split('\n');
  
  String? name;
  String? filename;
  String? contentType;
  
  for (final header in headers) {
    if (header.toLowerCase().startsWith('content-disposition:')) {
      final match = RegExp(r'name="([^"]+)"').firstMatch(header);
      if (match != null) name = match.group(1);
      
      final filenameMatch = RegExp(r'filename="([^"]+)"').firstMatch(header);
      if (filenameMatch != null) filename = filenameMatch.group(1);
    }
    if (header.toLowerCase().startsWith('content-type:')) {
      contentType = header.split(':')[1].trim();
    }
  }
  
  // Get body data (skip trailing CRLF)
  final bodyStart = separatorIndex;
  int bodyEnd = data.length;
  if (bodyEnd > 0 && data[bodyEnd - 1] == 10) bodyEnd--;
  if (bodyEnd > 0 && data[bodyEnd - 1] == 13) bodyEnd--;
  
  final bodyData = data.sublist(bodyStart, bodyEnd);
  
  result['name'] = name;
  result['filename'] = filename;
  result['content-type'] = contentType;
  result['data'] = bodyData;
  
  return result;
}

