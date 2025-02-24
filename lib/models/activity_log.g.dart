// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityLogImpl _$$ActivityLogImplFromJson(Map<String, dynamic> json) =>
    _$ActivityLogImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      eventType: $enumDecode(_$ActivityEventTypeEnumMap, json['eventType']),
      eventTimestamp: DateTime.parse(json['eventTimestamp'] as String),
    );

Map<String, dynamic> _$$ActivityLogImplToJson(_$ActivityLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'eventType': _$ActivityEventTypeEnumMap[instance.eventType]!,
      'eventTimestamp': instance.eventTimestamp.toIso8601String(),
    };

const _$ActivityEventTypeEnumMap = {
  ActivityEventType.registration: 'registration',
  ActivityEventType.password_change: 'password_change',
  ActivityEventType.profile_update: 'profile_update',
  ActivityEventType.role_change: 'role_change',
  ActivityEventType.course_purchase: 'course_purchase',
  ActivityEventType.article_save: 'article_save',
};
