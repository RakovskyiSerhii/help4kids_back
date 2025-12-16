import 'package:freezed_annotation/freezed_annotation.dart';
part 'finance_info.freezed.dart';
part 'finance_info.g.dart';

@freezed
class FinanceInfo with _$FinanceInfo {
  const factory FinanceInfo({
    required String id,
    required String tNumber,
    required String name,
    required String officialAddress,
    required String actualAddress,
  }) = _FinanceInfo;

  factory FinanceInfo.fromJson(Map<String, dynamic> json) =>
      _$FinanceInfoFromJson(json);

  factory FinanceInfo.fromRow(Map<String, dynamic> row) {
    return FinanceInfo(
      id: row['id'].toString(),
      tNumber: row['t_number'].toString(),
      name: row['name'].toString(),
      officialAddress: row['official_address'].toString(),
      actualAddress: row['actual_address'].toString(),
    );
  }
}