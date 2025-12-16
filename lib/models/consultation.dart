import 'package:freezed_annotation/freezed_annotation.dart';

part 'consultation.freezed.dart';
part 'consultation.g.dart';

@freezed
class Consultation with _$Consultation {
  const factory Consultation({
    required String id,
    required String title,
    required String shortDescription,
    required double price,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
    String? updatedBy,
  }) = _Consultation;

  factory Consultation.fromJson(Map<String, dynamic> json) =>
      _$ConsultationFromJson(json);

  factory Consultation.fromMap(Map<String, dynamic> map) {
    return Consultation(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      shortDescription: map['short_description']?.toString() ?? '',
      price: double.tryParse(map['price']?.toString() ?? '0') ?? 0,
      createdAt: DateTime.parse(map['created_at'].toString()),
      updatedAt: DateTime.parse(map['updated_at'].toString()),
      createdBy: map['created_by']?.toString(),
      updatedBy: map['updated_by']?.toString(),
    );
  }
}