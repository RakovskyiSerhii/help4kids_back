import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:help4kids/models/article.dart';
import 'package:help4kids/models/consultation.dart';
import 'package:help4kids/models/service.dart';
import 'package:help4kids/models/staff.dart';

part 'landing.freezed.dart';
part 'landing.g.dart';

@freezed
class LandingResponse with _$LandingResponse {
  const factory LandingResponse({
    required List<Service> featuredServices,
    required List<Staff> featuredStaff,
    required List<Consultation> featuredConsultations,
    required List<Article> featuredArticles,
  }) = _LandingResponse;

  factory LandingResponse.fromJson(Map<String, dynamic> json) =>
      _$LandingResponseFromJson(json);

  Map<String, dynamic> toJson() => {
    'featuredServices': featuredServices.map((e) => e.toJson()).toList(),
    'featuredStaff': featuredStaff.map((e) => e.toJson()).toList(),
    'featuredConsultations': featuredConsultations.map((e) => e.toJson()).toList(),
    'featuredArticles': featuredArticles.map((e) => e.toJson()).toList(),
  };
}