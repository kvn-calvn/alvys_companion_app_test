import 'package:freezed_annotation/freezed_annotation.dart';

part 'echeck.freezed.dart';
part 'echeck.g.dart';

@freezed
class ECheck with _$ECheck {
  factory ECheck({
    @JsonKey(name: 'Amount') double? amount,
    @JsonKey(name: 'AmountUsed') double? amountUsed,
    @JsonKey(name: 'ExpressCheckNumber') String? expressCheckNumber,
    @JsonKey(name: 'ECheckId') String? eCheckId,
    @JsonKey(name: 'Reason') String? reason,
  }) = _ECheck;
  factory ECheck.fromJson(Map<String, dynamic> json) => _$ECheckFromJson(json);
}
