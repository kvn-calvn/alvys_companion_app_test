import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_error.freezed.dart';
part 'client_error.g.dart';

@freezed
class ClientError with _$ClientError {
  factory ClientError({
    @JsonKey(name: "Title") String? title,
    @JsonKey(name: "Content") String? content,
  }) = _ClientError;

  factory ClientError.fromJson(Map<String, dynamic> json) =>
      _$ClientErrorFromJson(json);
}
