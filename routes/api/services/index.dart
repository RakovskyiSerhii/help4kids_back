import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/models/service_price.dart';
import 'package:help4kids/services/service_service.dart';
import 'package:help4kids/middleware/auth_middleware.dart';
import 'package:help4kids/constants/roles.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context) async {
  // GET /api/services: List all services (public)
  if (context.request.method == HttpMethod.get) {
    try {
      final services = await ServiceService.getAllServices();
      // Frontend Retrofit client expects a top-level JSON array of services.
      return Response.json(
        body: services.map((s) => s.toJson()).toList(),
      );
    } catch (e) {
      return ResponseHelpers.error(
        ApiErrors.internalError('Failed to fetch services'),
      );
    }
  }
  // POST /api/services: Create a new service (admin/god only)
  else if (context.request.method == HttpMethod.post) {
    // Apply auth middleware
    final handler = authMiddleware((context) async {
      try {
        // Check if user has admin or god role
        final payload = context.read<JwtPayload>();
        if (!Roles.isAdmin(payload.roleId)) {
          return ResponseHelpers.error(ApiErrors.forbidden());
        }
        final body = await context.request.json() as Map<String, dynamic>;

        // Validate required fields
        final title = body['title'] as String?;
        final shortDescription = body['shortDescription'] as String?;
        final icon = body['icon'] as String?;
        final price = body['price'] as num?;
        final repeatPrice = body['repeatPrice'] as num?;
        final customPriceString = body['customPriceString'] as String?;
        final customRangePrice = body['customRangePrice'] as Map<String, num>?;
        final categoryId = body['categoryId'] as String?;

        if (title == null ||
            shortDescription == null ||
            icon == null ||
            price == null ||
            categoryId == null) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Missing required fields: title, shortDescription, icon, price, categoryId'),
          );
        }

        // Validate field values
        if (!Validation.isNotEmpty(title)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Title cannot be empty'),
          );
        }

        if (!Validation.isNotEmpty(shortDescription)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Short description cannot be empty'),
          );
        }

        if (!Validation.isPositive(price)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Price must be positive'),
          );
        }

        if (!Validation.isValidUuid(categoryId)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Invalid category ID format'),
          );
        }

        // Optional fields
        final longDescription = body['longDescription'] as String?;
        final image = body['image'] as String?;
        final duration = body['duration'] as int?;

        if (duration != null && !Validation.isPositive(duration)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Duration must be positive'),
          );
        }

        final service = await ServiceService.createService(
          title: title.trim(),
          shortDescription: shortDescription.trim(),
          longDescription: longDescription?.trim(),
          image: image?.trim(),
          icon: icon.trim(),
          price: ServicePrice(
            price: price.toDouble(),
            repeatPrice: repeatPrice?.toDouble(),
            customPriceString: customPriceString?.trim(),
            customRangePrices: customRangePrice?.map(
                  (key, value) => MapEntry(key, value.toDouble()),
                ) ??
                {},
          ),
          duration: duration,
          categoryId: categoryId,
        );
        return ResponseHelpers.success(service.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to create service: ${e.toString()}'),
        );
      }
    });

    return handler(context);
  }
  return ResponseHelpers.methodNotAllowed();
}
