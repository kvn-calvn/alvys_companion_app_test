import 'package:freezed_annotation/freezed_annotation.dart';

import 'data.dart';

part 'trip_details.freezed.dart';
part 'trip_details.g.dart';

@freezed
class TripDetails with _$TripDetails {
  factory TripDetails({
    @JsonKey(name: 'Data') Data? data,
    @JsonKey(name: 'ErrorMessage') String? errorMessage,
    @JsonKey(name: 'ErrorCode') int? errorCode,
  }) = _TripDetails;

  factory TripDetails.fromJson(Map<String, dynamic> json) =>
      _$TripDetailsFromJson(json);
}
