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

      final units = unitResults.map((row) => Unit.fromRow(row.fields)).toList();
      final socialContacts =
          socialResults.map((row) => SocialContact.fromRow(row.fields)).toList();
      final financeInfos =
          financeResults.map((row) => FinanceInfo.fromRow(row.fields)).toList();
      final consultation = consultationResults
          .map((row) => Consultation.fromMap(row.fields))
          .toList();
      final serviceCategories = serviceCategoryResults
          .map((row) => ServiceCategory(
                id: row['id']?.toString() ?? '',
                name: row['name']?.toString() ?? '',
                iconUrl: row['iconUrl']?.toString() ?? '',
                description: row['description']?.toString() ?? '',
              ))
          .toList();

      final response = {
        'units': units.map((e) => e.toJson()).toList(),
        'socialContacts': socialContacts.map((e) => e.toJson()).toList(),
        'financeInfo': financeInfos.map((e) => e.toJson()).toList(),
        'consultations': consultation.map((e) => e.toJson()).toList(),
        'serviceCategories': serviceCategories.map((e) => e.toJson()).toList(),
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
