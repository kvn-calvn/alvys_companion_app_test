import 'package:freezed_annotation/freezed_annotation.dart';

part 'phonenumber.freezed.dart';
part 'phonenumber.g.dart';

@freezed
class Phonenumber with _$Phonenumber {
  factory Phonenumber({
    @JsonKey(name: 'Data') String? data,
    @JsonKey(name: 'ErrorMessage') dynamic errorMessage,
    @JsonKey(name: 'ErrorCode') int? errorCode,
  }) = _Phonenumber;

  factory Phonenumber.fromJson(Map<String, dynamic> json) =>
      _$PhonenumberFromJson(json);
}
