// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LandingResponseImpl _$$LandingResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$LandingResponseImpl(
      featuredServices: (json['featuredServices'] as List<dynamic>)
          .map((e) => Service.fromJson(e as Map<String, dynamic>))
          .toList(),
      featuredStaff: (json['featuredStaff'] as List<dynamic>)
          .map((e) => Staff.fromJson(e as Map<String, dynamic>))
          .toList(),
      featuredConsultations: (json['featuredConsultations'] as List<dynamic>)
          .map((e) => Consultation.fromJson(e as Map<String, dynamic>))
          .toList(),
      featuredArticles: (json['featuredArticles'] as List<dynamic>)
          .map((e) => Article.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$LandingResponseImplToJson(
        _$LandingResponseImpl instance) =>
    <String, dynamic>{
      'featuredServices': instance.featuredServices,
      'featuredStaff': instance.featuredStaff,
      'featuredConsultations': instance.featuredConsultations,
      'featuredArticles': instance.featuredArticles,
    };
