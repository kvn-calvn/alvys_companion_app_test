import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_commission.freezed.dart';
part 'user_commission.g.dart';

@freezed
class UserCommission with _$UserCommission {
  factory UserCommission({
    @JsonKey(name: 'Month') int? month,
    @JsonKey(name: 'Year') int? year,
    @JsonKey(name: 'LoadNumber') String? loadNumber,
    @JsonKey(name: 'LoadCommission') double? loadCommission,
  }) = _UserCommission;

  factory UserCommission.fromJson(Map<String, dynamic> json) =>
      _$UserCommissionFromJson(json);
}
