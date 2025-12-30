import 'dart:convert';
import 'package:mysql1/mysql1.dart';
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
    final questionValue = map['question'];
    if (questionValue != null) {
      final questionStr = _toStringValue(questionValue);
      if (questionStr.isNotEmpty) {
        // If it's a JSON string, parse it
        try {
          questionMap = Map<String, dynamic>.from(
            jsonDecode(questionStr) as Map,
          );
        } catch (e) {
          // If parsing fails, try to use it as a list
          try {
            final list = jsonDecode(questionStr) as List;
            questionMap = {'questions': list};
          } catch (_) {
            questionMap = null;
          }
        }
      }
    }

    // Parse dates safely
    DateTime parseDate(dynamic dateValue) {
      if (dateValue == null) return DateTime.now();
      try {
        if (dateValue is DateTime) return dateValue;
        return DateTime.parse(_toStringValue(dateValue));
      } catch (e) {
        return DateTime.now();
      }
    }

    return Consultation(
      id: _toStringValue(map['id']),
      title: _toStringValue(map['title']),
      shortDescription: map['short_description'] != null ? _toStringValue(map['short_description']) : null,
      description: map['description'] != null ? _toStringValue(map['description']) : null,
      price: double.tryParse(_toStringValue(map['price'])) ?? 0,
      duration: map['duration'] != null ? _toStringValue(map['duration']) : null,
      question: questionMap,
      featured: map['featured'] == 1 || map['featured'] == true,
      createdAt: parseDate(map['created_at']),
      updatedAt: parseDate(map['updated_at']),
      createdBy: map['created_by'] != null ? _toStringValue(map['created_by']) : null,
      updatedBy: map['updated_by'] != null ? _toStringValue(map['updated_by']) : null,
    );
  }

  static String _toStringValue(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is Blob) {
      return utf8.decode(value.toList());
    }
    return value.toString();
  }
}