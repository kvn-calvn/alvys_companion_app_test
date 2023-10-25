import 'package:freezed_annotation/freezed_annotation.dart';

part 'payable_driver.freezed.dart';
part 'payable_driver.g.dart';

@freezed
class PayableDriverAmount with _$PayableDriverAmount {
  const factory PayableDriverAmount({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'Amount') double? amount,
  }) = _PayableDriverAmount;

  factory PayableDriverAmount.fromJson(Map<String, dynamic> json) =>
      _$PayableDriverAmountFromJson(json);
}
