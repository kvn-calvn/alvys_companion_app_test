import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_error.freezed.dart';
part 'client_error.g.dart';

@freezed
class ClientError with _$ClientError {
  factory ClientError({
    String? title,
    String? details,
    required int status,
    required Map<String, Map<String, List<String>>> errors,
  }) = _ClientError;
  ClientError._();
  factory ClientError.fromJson(Map<String, dynamic> json) => _$ClientErrorFromJson(json);
}
