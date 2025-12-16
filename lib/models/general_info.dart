import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:help4kids/models/consultation.dart';
import 'unit.dart';
import 'social_contact.dart';
import 'finance_info.dart';

part 'general_info.freezed.dart';
part 'general_info.g.dart';

@freezed
class GeneralInfo with _$GeneralInfo {
  const factory GeneralInfo({
    required List<Unit> units,
    required List<SocialContact> socialContacts,
    required List<FinanceInfo> financeInfos,
    required List<Consultation> consultations,
  }) = _GeneralInfo;

  factory GeneralInfo.fromJson(Map<String, dynamic> json) => _$GeneralInfoFromJson(json);

}