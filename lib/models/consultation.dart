import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'consultation.freezed.dart';
part 'consultation.g.dart';

@freezed
class Consultation with _$Consultation {
  const factory Consultation({
    required String id,
    required String title,
    String? shortDescription,
    String? description,
    required double price,
    String? duration,
    Map<String, dynamic>? question,
    @Default(false) bool featured,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
    String? updatedBy,
  }) = _Consultation;

  factory Consultation.fromJson(Map<String, dynamic> json) =>
      _$ConsultationFromJson(json);

  factory Consultation.fromMap(Map<String, dynamic> map) {
    // Parse question JSON if it exists
    Map<String, dynamic>? questionMap;
    if (map['question'] != null) {
      if (map['question'] is String) {
        // If it's a JSON string, parse it
        try {
          questionMap = Map<String, dynamic>.from(
            jsonDecode(map['question'] as String) as Map,
          );
        } catch (e) {
          // If parsing fails, try to use it as a list
          try {
            final list = jsonDecode(map['question'] as String) as List;
            questionMap = {'questions': list};
          } catch (_) {
            questionMap = null;
          }
        }
      } else if (map['question'] is Map) {
        questionMap = Map<String, dynamic>.from(map['question'] as Map);
      }
    }

    // Parse dates safely
    DateTime parseDate(dynamic dateValue) {
      if (dateValue == null) return DateTime.now();
      try {
        if (dateValue is DateTime) return dateValue;
        return DateTime.parse(dateValue.toString());
      } catch (e) {
        return DateTime.now();
      }
    }

    return Consultation(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      shortDescription: map['short_description']?.toString(),
      description: map['description']?.toString(),
      price: double.tryParse(map['price']?.toString() ?? '0') ?? 0,
      duration: map['duration']?.toString(),
      question: questionMap,
      featured: map['featured'] == 1 || map['featured'] == true,
      createdAt: parseDate(map['created_at']),
      updatedAt: parseDate(map['updated_at']),
      createdBy: map['created_by']?.toString(),
      updatedBy: map['updated_by']?.toString(),
    );
  }
}