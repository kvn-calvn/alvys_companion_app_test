import 'package:freezed_annotation/freezed_annotation.dart';

part 'phonenumber_error.freezed.dart';
part 'phonenumber_error.g.dart';

@freezed
class PhonenumberError with _$PhonenumberError {
  factory PhonenumberError({
    @JsonKey(name: 'ErrorMessage') String? errorMessage,
    @JsonKey(name: 'ErrorCode') int? errorCode,
    @JsonKey(name: 'ResponseId') String? responseId,
  }) = _PhonenumberError;

  factory PhonenumberError.fromJson(Map<String, dynamic> json) =>
      _$PhonenumberErrorFromJson(json);
}
