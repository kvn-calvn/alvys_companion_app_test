import 'package:freezed_annotation/freezed_annotation.dart';

part 'generate_echeck_request.freezed.dart';
part 'generate_echeck_request.g.dart';

@freezed
class GenerateECheckRequest with _$GenerateECheckRequest {
  factory GenerateECheckRequest() = _GenerateECheckRequest;

  factory GenerateECheckRequest.fromJson(Map<String, dynamic> json) =>
      _$GenerateECheckRequestFromJson(json);
}
