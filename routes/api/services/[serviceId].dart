import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/service_service.dart';

Future<Response> onRequest(RequestContext context, String serviceId) async {
  // GET /api/services/{serviceId}: Retrieve service details (public)
  if (context.request.method == HttpMethod.get) {
    final service = await ServiceService.getServiceById(serviceId);
    if (service == null) {
      return Response.json(
        body: {'error': 'Service not found'},
        statusCode: 404,
      );
    }
    return Response.json(body: service.toJson());
  }
  // PUT /api/services/{serviceId}: Update service details (admin/god only)
  else if (context.request.method == HttpMethod.put) {
    final role = context.request.headers['x-role'] ?? 'customer';
    if (role != 'admin' && role != 'god') {
      return Response.json(
        body: {'error': 'Unauthorized'},
        statusCode: 403,
      );
    }
    final body = await context.request.json();
    final success = await ServiceService.updateService(serviceId, body);
    if (!success) {
      return Response.json(
        body: {'error': 'Update failed'},
        statusCode: 400,
      );
    }
    final updatedService = await ServiceService.getServiceById(serviceId);
    return Response.json(body: updatedService?.toJson() ?? {});
  }
  // DELETE /api/services/{serviceId}: Delete service (admin/god only)
  else if (context.request.method == HttpMethod.delete) {
    final role = context.request.headers['x-role'] ?? 'customer';
    if (role != 'admin' && role != 'god') {
      return Response.json(
        body: {'error': 'Unauthorized'},
        statusCode: 403,
      );
    }
    final success = await ServiceService.deleteService(serviceId);
    if (!success) {
      return Response.json(
        body: {'error': 'Deletion failed'},
        statusCode: 400,
      );
    }
    return Response.json(body: {'message': 'Service deleted successfully'});
  }
  return Response(statusCode: 405);
}