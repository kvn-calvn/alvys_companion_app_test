import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_error.freezed.dart';
part 'client_error.g.dart';

@freezed
class ClientError with _$ClientError {
  factory ClientError({
    String? title,
    String? detail,
    required int status,
    required Map<String, List<String>> errors,
  }) = _ClientError;
  ClientError._();
  factory ClientError.fromJson(Map<String, dynamic> json) => _$ClientErrorFromJson(json);
}

@freezed
class DependencyError with _$DependencyError {
  factory DependencyError({required String title, required int status, required String? detail}) = _DependencyError;

  factory DependencyError.fromJson(Map<String, dynamic> json) => _$DependencyErrorFromJson(json);
}

@freezed
class NotFoundError with _$NotFoundError {
  factory NotFoundError({required int status, required String title}) = _NotFoundError;

  factory NotFoundError.fromJson(Map<String, dynamic> json) => _$NotFoundErrorFromJson(json);
}
