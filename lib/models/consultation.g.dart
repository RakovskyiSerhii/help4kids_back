// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConsultationImpl _$$ConsultationImplFromJson(Map<String, dynamic> json) =>
    _$ConsultationImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      shortDescription: json['shortDescription'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      duration: json['duration'] as String?,
      question: json['question'] as Map<String, dynamic>?,
      featured: json['featured'] as bool? ?? false,
      bookingId: json['bookingId'] as String?,
      paymentUrl: json['paymentUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
    );

Map<String, dynamic> _$$ConsultationImplToJson(_$ConsultationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'shortDescription': instance.shortDescription,
      'description': instance.description,
      'price': instance.price,
      'duration': instance.duration,
      'question': instance.question,
      'featured': instance.featured,
      'bookingId': instance.bookingId,
      'paymentUrl': instance.paymentUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
    };
