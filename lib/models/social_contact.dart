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
      id: row['id'].toString(),
      url: row['url'].toString(),
      name: row['name'].toString(),
    );
  }
}