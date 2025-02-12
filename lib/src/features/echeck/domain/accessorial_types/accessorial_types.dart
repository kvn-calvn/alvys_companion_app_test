import 'package:freezed_annotation/freezed_annotation.dart';

part 'accessorial_types.freezed.dart';
part 'accessorial_types.g.dart';

@freezed
class GetAccessorialTypesResponse with _$GetAccessorialTypesResponse {
  factory GetAccessorialTypesResponse({
    @JsonKey(name: "Id") required String id,
    @JsonKey(name: "Name") required String name,
    @JsonKey(name: "RequiresStop") required bool requiresStop,
  }) = _GetAccessorialTypesResponse;

  factory GetAccessorialTypesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAccessorialTypesResponseFromJson(json);
}
