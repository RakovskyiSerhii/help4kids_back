import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/services/consultation_service.dart';
import 'package:help4kids/utils/auth_helpers.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/validation.dart';
import 'package:help4kids/utils/response_helpers.dart';

Future<Response> onRequest(RequestContext context) async {
  // GET /api/consultations: List all available consultations
  if (context.request.method == HttpMethod.get) {
    try {
      final consultations = await ConsultationService.getAllConsultations();
      return ResponseHelpers.success(
        {'consultations': consultations.map((c) => c.toJson()).toList()},
      );
    } catch (e) {
      return ResponseHelpers.error(
        ApiErrors.internalError('Failed to fetch consultations'),
      );
    }
  }
  // POST /api/consultations: Create a new consultation (admin/god only)
  else if (context.request.method == HttpMethod.post) {
    final handler = requireAdmin((context) async {
      try {
        final body = await context.request.json() as Map<String, dynamic>;
        final title = body['title'] as String?;
        final shortDescription = body['shortDescription'] as String?;
        final price = body['price'] as num?;

        if (title == null || shortDescription == null || price == null) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Missing required fields: title, shortDescription, price'),
          );
        }

        // Enhanced validation per frontend requirements
        if (title.trim().length < 3 || title.trim().length > 200) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Title must be between 3 and 200 characters'),
          );
        }

        if (!Validation.isPositive(price)) {
          return ResponseHelpers.error(
            ApiErrors.validationError('Price must be positive'),
          );
        }

        // Optional fields
        final bookingId = body['bookingId'] as String?;
        final paymentUrl = body['paymentUrl'] as String?;

        final payload = context.read<JwtPayload>();
        final description = body['description'] as String?;
        final duration = body['duration'] as String?;
        final question = body['question'] as Map<String, dynamic>?;
        final featured = body['featured'] as bool? ?? false;
        
        final consultation = await ConsultationService.createConsultation(
          title: title.trim(),
          shortDescription: shortDescription.trim(),
          description: description?.trim(),
          price: price.toDouble(),
          duration: duration?.trim(),
          question: question,
          featured: featured,
          bookingId: bookingId?.trim(),
          paymentUrl: paymentUrl?.trim(),
          createdBy: payload.id,
        );
        return ResponseHelpers.success(consultation.toJson());
      } catch (e) {
        return ResponseHelpers.error(
          ApiErrors.internalError('Failed to create consultation'),
        );
      }
    });

    return handler(context);
  }
  return ResponseHelpers.methodNotAllowed();
}