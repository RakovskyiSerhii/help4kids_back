import 'dart:convert';
import 'package:mysql1/mysql1.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'unit.freezed.dart';
part 'unit.g.dart';

@freezed
class Unit with _$Unit {
  const factory Unit({
    required String id,
    required String address,
    required Map<String, String?> workingTime,
    required String contactPhone,
    required String email,
    String? socialUrl,
  }) = _Unit;

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);

  // Optional: If you want to construct from a DB row map
  factory Unit.fromRow(Map<String, dynamic> row) {
    final workingTimeStr = _toStringValue(row['working_time']);
    final workingTime = Map.of(jsonDecode(workingTimeStr));
    return Unit(
      id: _toStringValue(row['id']),
      address: _toStringValue(row['address']),
      workingTime: {
        'workdays': workingTime['workdays'].toString(),
        'Saturday': workingTime['Saturday'].toString(),
        'Sunday': workingTime['Sunday'].toString(),
      },
      contactPhone: _toStringValue(row['contact_phone']),
      email: _toStringValue(row['email']),
      socialUrl: row['social_url'] != null ? _toStringValue(row['social_url']) : null,
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