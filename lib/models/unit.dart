import 'dart:convert';

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
    final workingTime = Map.of(jsonDecode(row['working_time']));
    return Unit(
      id: row['id'].toString(),
      address: row['address'].toString(),
      workingTime: {
        'workdays': workingTime['workdays'].toString(),
        'Saturday': workingTime['Saturday'].toString(),
        'Sunday': workingTime['Sunday'].toString(),
      },
      contactPhone: row['contact_phone'].toString(),
      email: row['email'].toString(),
      socialUrl: row['social_url']?.toString(),
    );
  }
}