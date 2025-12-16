import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/landing_service.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.get) {
    try {
      final landing = await LandingService.getFeaturedContent();
      return ResponseHelpers.success(landing);
    } catch (e) {
      return ResponseHelpers.error(
        ApiErrors.internalError('Failed to fetch landing data'),
      );
    }
  }
  return ResponseHelpers.methodNotAllowed();
}