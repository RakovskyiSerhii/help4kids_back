import 'package:mysql1/mysql1.dart';
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
      id: _toStringValue(row['id']),
      tNumber: _toStringValue(row['t_number']),
      name: _toStringValue(row['name']),
      officialAddress: _toStringValue(row['official_address']),
      actualAddress: _toStringValue(row['actual_address']),
    );
  }

  static String _toStringValue(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is Blob) {
      return value.toString();
    }
    return value.toString();
  }
}