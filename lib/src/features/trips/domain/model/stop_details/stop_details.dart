import 'package:freezed_annotation/freezed_annotation.dart';

import 'data.dart';

part 'stop_details.freezed.dart';
part 'stop_details.g.dart';

@freezed
class StopDetails with _$StopDetails {
  factory StopDetails({
    @JsonKey(name: 'Data') Data? data,
    @JsonKey(name: 'ErrorMessage') String? errorMessage,
    @JsonKey(name: 'ErrorCode') int? errorCode,
  }) = _StopDetails;

  factory StopDetails.fromJson(Map<String, dynamic> json) =>
      _$StopDetailsFromJson(json);
}
