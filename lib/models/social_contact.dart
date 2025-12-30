import 'dart:convert';
import 'package:mysql1/mysql1.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'social_contact.freezed.dart';
part 'social_contact.g.dart';

@freezed
class SocialContact with _$SocialContact {
  const factory SocialContact({
    required String id,
    required String url,
    required String name,
  }) = _SocialContact;

  factory SocialContact.fromJson(Map<String, dynamic> json) => _$SocialContactFromJson(json);

  factory SocialContact.fromRow(Map<String, dynamic> row) {
    return SocialContact(
      id: _toStringValue(row['id']),
      url: _toStringValue(row['url']),
      name: _toStringValue(row['name']),
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