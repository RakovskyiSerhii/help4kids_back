import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/service_service.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context, String serviceId) async {
  // GET /api/services/{serviceId}: Retrieve service details (public)
  if (context.request.method == HttpMethod.get) {
    try {
      if (!Validation.isValidUuid(serviceId)) {
        return ResponseHelpers.error(
          ApiErrors.validationError('Invalid service ID format'),
        );
      }
      final service = await ServiceService.getServiceById(serviceId);
      if (service == null) {
        return ResponseHelpers.error(ApiErrors.notFound('Service'));
      }
      return ResponseHelpers.success(service.toJson());
    } catch (e) {
      return ResponseHelpers.error(
        ApiErrors.internalError('Failed to fetch service'),
      );
    }
  }
  // PUT /api/services/{serviceId}: Update service details (admin/god only)
  else if (context.request.method == HttpMethod.put) {
    final handler = requireAdmin((context) async {
      try {
        if (!Validation.isValidUuid(serviceId)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Invalid service ID format'),
          );
        }
        final body = await context.request.json() as Map<String, dynamic>;
        final success = await ServiceService.updateService(serviceId, body);
        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Update failed'),
          );
        }
        final updatedService = await ServiceService.getServiceById(serviceId);
        if (updatedService == null) {
          return ResponseHelpers.error(ApiErrors.notFound('Service'));
        }
        return ResponseHelpers.success(updatedService.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to update service'),
        );
      }
    });
    return handler(context);
  }
  // DELETE /api/services/{serviceId}: Delete service (admin/god only)
  else if (context.request.method == HttpMethod.delete) {
    final handler = requireAdmin((context) async {
      try {
        if (!Validation.isValidUuid(serviceId)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Invalid service ID format'),
          );
        }
        final success = await ServiceService.deleteService(serviceId);
        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Deletion failed'),
          );
        }
        return ResponseHelpers.success({'message': 'Service deleted successfully'});
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to delete service'),
        );
      }
    });
    return handler(context);
  }
  return ResponseHelpers.methodNotAllowed();
}