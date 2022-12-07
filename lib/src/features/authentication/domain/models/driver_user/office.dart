import 'package:freezed_annotation/freezed_annotation.dart';

import 'address.dart';

part 'office.freezed.dart';
part 'office.g.dart';

@freezed
class Office with _$Office {
  factory Office({
    @JsonKey(name: 'Id') String? id,
    @JsonKey(name: 'Name') String? name,
    @JsonKey(name: 'Address') Address? address,
    @JsonKey(name: 'CommissionRate') double? commissionRate,
    @Default(false) @JsonKey(name: 'IsDeleted') bool isDeleted,
    @JsonKey(name: 'SharedWith') Share? shreadWith,
    @JsonKey(name: 'CompanyCode') String? companyCode,
  }) = _Office;

  factory Office.fromJson(Map<String, dynamic> json) => _$OfficeFromJson(json);
}

@freezed
class Share with _$Share {
  factory Share({
    @Default(<String>[]) @JsonKey(name: 'Users') List<String> users,
    @Default(<String>[]) @JsonKey(name: 'Groups') List<String> groups,
  }) = _Share;

  factory Share.fromJson(Map<String, dynamic> json) => _$ShareFromJson(json);
}
