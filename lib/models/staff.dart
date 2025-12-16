import 'package:freezed_annotation/freezed_annotation.dart';
part 'staff.freezed.dart';
part 'staff.g.dart';

@freezed
class Staff with _$Staff {
  const factory Staff({
    required String id,
    required String name,
    String? content,
    String? photoUrl,
    @Default(false) bool featured,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Staff;

  factory Staff.fromJson(Map<String, dynamic> json) => _$StaffFromJson(json);
}