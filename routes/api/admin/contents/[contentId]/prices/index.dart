import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/content_service.dart';
import 'package:help4kids/models/content_price.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context, String contentId) async {
  final handler = requireAdmin((context) async {
    // Validate content ID format
    if (!Validation.isValidUuid(contentId)) {
      return ResponseHelpers.error(
        ApiErrors.validationError('Invalid content ID format'),
      );
    }

    // GET /api/admin/contents/{contentId}/prices - Get all prices for content
    if (context.request.method == HttpMethod.get) {
      try {
        final prices = await ContentService.getContentPrices(contentId);
        return ResponseHelpers.success({
          'prices': prices.map((p) => p.toJson()).toList(),
        });
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to fetch prices'),
        );
      }
    }

    // POST /api/admin/contents/{contentId}/prices - Create new price
    if (context.request.method == HttpMethod.post) {
      try {
        final body = await context.request.json() as Map<String, dynamic>;

        // Validate required fields
        final price = body['price'] as num?;
        if (price == null || !Validation.isPositive(price)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Price must be a positive number'),
          );
        }

        // Validate access type
        final accessTypeStr = body['accessType'] as String? ?? 'lifetime';
        AccessType accessType;
        try {
          accessType = AccessType.values.firstWhere(
            (e) => e.name == accessTypeStr,
          );
        } catch (e) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Invalid accessType. Must be: lifetime or timeLimited'),
          );
        }

        // Validate duration for time-limited access
        if (accessType == AccessType.timeLimited) {
          final duration = body['accessDurationMonths'] as num?;
          if (duration == null || !Validation.isPositive(duration)) {
            return ResponseHelpers.error(
              ApiErrors.validationError('accessDurationMonths is required for timeLimited access'),
            );
          }
        }

        final contentPrice = await ContentService.createContentPrice(
          contentId: contentId,
          price: price.toDouble(),
          currency: body['currency'] as String? ?? 'UAH',
          accessType: accessType,
          accessDurationMonths: accessType == AccessType.timeLimited
              ? (body['accessDurationMonths'] as num).toInt()
              : null,
          description: body['description'] as String?,
          isDefault: body['isDefault'] as bool? ?? false,
          ordering: (body['ordering'] as num?)?.toInt() ?? 0,
        );

        return ResponseHelpers.success(contentPrice.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to create price: ${e.toString()}'),
        );
      }
    }

    return ResponseHelpers.methodNotAllowed();
  });

  return handler(context);
}

