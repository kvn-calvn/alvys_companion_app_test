import 'package:freezed_annotation/freezed_annotation.dart';

import '../app_trip/app_trip.dart';

part 'trip_details.freezed.dart';
part 'trip_details.g.dart';

@freezed
class TripDetails with _$TripDetails {
  factory TripDetails({
    @JsonKey(name: 'Data') AppTrip? data,
    @JsonKey(name: 'ErrorMessage') String? errorMessage,
    @JsonKey(name: 'ErrorCode') int? errorCode,
  }) = _TripDetails;

  factory TripDetails.fromJson(Map<String, dynamic> json) => _$TripDetailsFromJson(json);
}
