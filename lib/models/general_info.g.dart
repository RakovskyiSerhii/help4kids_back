// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GeneralInfoImpl _$$GeneralInfoImplFromJson(Map<String, dynamic> json) =>
    _$GeneralInfoImpl(
      units: (json['units'] as List<dynamic>)
          .map((e) => Unit.fromJson(e as Map<String, dynamic>))
          .toList(),
      socialContacts: (json['socialContacts'] as List<dynamic>)
          .map((e) => SocialContact.fromJson(e as Map<String, dynamic>))
          .toList(),
      financeInfos: (json['financeInfos'] as List<dynamic>)
          .map((e) => FinanceInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      consultations: (json['consultations'] as List<dynamic>)
          .map((e) => Consultation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$GeneralInfoImplToJson(_$GeneralInfoImpl instance) =>
    <String, dynamic>{
      'units': instance.units,
      'socialContacts': instance.socialContacts,
      'financeInfos': instance.financeInfos,
      'consultations': instance.consultations,
    };
