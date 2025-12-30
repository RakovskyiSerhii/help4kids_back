import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/models/consultation.dart';
import 'package:help4kids/models/finance_info.dart';
import 'package:help4kids/models/service_category.dart';
import 'package:help4kids/models/social_contact.dart';
import 'package:help4kids/models/unit.dart';
import 'package:help4kids/utils/errors.dart';
import 'package:help4kids/utils/response_helpers.dart';
import 'package:help4kids/utils/db_helper.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.get) {
    try {
      // Execute all queries in parallel for better performance
      final results = await DbHelper.parallelQueries([
        (conn) => conn.query("SELECT id, address, working_time, contact_phone, social_url, email, created_at, updated_at FROM unit"),
        (conn) => conn.query("SELECT id, url, name, created_at, updated_at FROM social_contacts"),
        (conn) => conn.query("SELECT id, t_number, name, official_address, actual_address, created_at, updated_at FROM finance_info"),
        (conn) => conn.query("SELECT id, title, short_description, description, price, featured, ordering, duration, question, created_at, updated_at FROM consultations"),
        (conn) => conn.query("SELECT id, name, description, iconUrl, featured, created_at, updated_at FROM service_categories"),
      ]);

      final unitResults = results[0];
      final socialResults = results[1];
      final financeResults = results[2];
      final consultationResults = results[3];
      final serviceCategoryResults = results[4];

      // Debug logging to check query results
      print('Query results count - units: ${unitResults.length}, social: ${socialResults.length}, finance: ${financeResults.length}, consultations: ${consultationResults.length}, categories: ${serviceCategoryResults.length}');

      final units = unitResults.map((row) => Unit.fromRow(row.fields)).toList();
      final socialContacts =
          socialResults.map((row) => SocialContact.fromRow(row.fields)).toList();
      final financeInfos = financeResults
          .map((row) {
            try {
              return FinanceInfo.fromRow(row.fields);
            } catch (e) {
              // Log error but continue processing other rows
              print('Error parsing finance info row: $e, row: ${row.fields}');
              return null;
            }
          })
          .whereType<FinanceInfo>()
          .toList();
      final consultation = consultationResults
          .map((row) {
            try {
              return Consultation.fromMap(row.fields);
            } catch (e) {
              // Log error but continue processing other rows
              print('Error parsing consultation row: $e, row: ${row.fields}');
              return null;
            }
          })
          .whereType<Consultation>()
          .toList();
      final serviceCategories = serviceCategoryResults
          .map((row) {
            try {
              final fields = row.fields;
              return ServiceCategory(
                id: fields['id']?.toString() ?? '',
                name: fields['name']?.toString() ?? '',
                iconUrl: fields['iconUrl']?.toString(),
                description: fields['description']?.toString(),
              );
            } catch (e) {
              // Log error but continue processing other rows
              print('Error parsing service category row: $e, row: ${row.fields}');
              return null;
            }
          })
          .whereType<ServiceCategory>()
          .toList();

      final response = {
        'units': units.map((e) => e.toJson()).toList(),
        'socialContacts': socialContacts.map((e) => e.toJson()).toList(),
        'financeInfo': financeInfos.map((e) => e.toJson()).toList(),
        'consultations': consultation.map((e) => e.toJson()).toList(),
        // Use the key expected by the frontend GeneralInfo.categories field.
        'categories': serviceCategories.map((e) => e.toJson()).toList(),
      };

      return ResponseHelpers.success(response);
    } catch (e) {
      return ResponseHelpers.error(
        ApiErrors.internalError('Failed to fetch general info'),
      );
    }
  }
  return ResponseHelpers.methodNotAllowed();
}
