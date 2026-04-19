import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/content_service.dart';
import 'package:help4kids/models/content_price.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(
  RequestContext context,
  String contentId,
  String priceId,
) async {
  final handler = requireAdmin((context) async {
    // Validate IDs
    if (!Validation.isValidUuid(contentId) || !Validation.isValidUuid(priceId)) {
      return ResponseHelpers.error(
        ApiErrors.validationError('Invalid ID format'),
      );
    }

    // PUT /api/admin/contents/{contentId}/prices/{priceId} - Update price
    if (context.request.method == HttpMethod.put) {
      try {
        final body = await context.request.json() as Map<String, dynamic>;
        final updates = <String, dynamic>{};

        if (body.containsKey('price')) {
          final price = body['price'] as num?;
          if (price == null || !Validation.isPositive(price)) {
            return ResponseHelpers.error(
              ApiErrors.validationError('Price must be a positive number'),
            );
          }
          updates['price'] = price.toDouble();
        }
        if (body.containsKey('currency')) {
          updates['currency'] = body['currency'] as String;
        }
        if (body.containsKey('accessType')) {
          try {
            updates['accessType'] = AccessType.values.firstWhere(
              (e) => e.name == body['accessType'],
            );
          } catch (e) {
            return ResponseHelpers.error(
              ApiErrors.validationError('Invalid accessType'),
            );
          }
        }
        if (body.containsKey('accessDurationMonths')) {
          updates['accessDurationMonths'] = (body['accessDurationMonths'] as num).toInt();
        }
        if (body.containsKey('description')) {
          updates['description'] = body['description'] as String?;
        }
        if (body.containsKey('isDefault')) {
          updates['isDefault'] = body['isDefault'] as bool;
        }
        if (body.containsKey('ordering')) {
          updates['ordering'] = (body['ordering'] as num).toInt();
        }

        if (updates.isEmpty) {
          return ResponseHelpers.error(
            ApiErrors.validationError('No valid fields to update'),
          );
        }

        final success = await ContentService.updateContentPrice(priceId, updates);
        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Failed to update price'),
          );
        }

        final updatedPrice = await ContentService.getContentPriceById(priceId);
        return ResponseHelpers.success(updatedPrice?.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to update price: ${e.toString()}'),
        );
      }
    }

    // DELETE /api/admin/contents/{contentId}/prices/{priceId} - Delete price
    if (context.request.method == HttpMethod.delete) {
      try {
        final success = await ContentService.deleteContentPrice(priceId);
        if (!success) {
          return ResponseHelpers.error(
            ApiErrors.badRequest('Failed to delete price'),
          );
        }
        return ResponseHelpers.success({'message': 'Price deleted successfully'});
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to delete price'),
        );
      }
    }

    return ResponseHelpers.methodNotAllowed();
  });

  return handler(context);
}

