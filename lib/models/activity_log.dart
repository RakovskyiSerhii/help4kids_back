import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_log.freezed.dart';
part 'activity_log.g.dart';

enum ActivityEventType {
  registration,
  password_change,
  profile_update,
  role_change,
  course_purchase,
  article_save,
}

@freezed
class ActivityLog with _$ActivityLog {
  const factory ActivityLog({
    required String id,
    required String userId,
    required ActivityEventType eventType,
    required DateTime eventTimestamp,
  }) = _ActivityLog;

  factory ActivityLog.fromJson(Map<String, dynamic> json) => _$ActivityLogFromJson(json);
}