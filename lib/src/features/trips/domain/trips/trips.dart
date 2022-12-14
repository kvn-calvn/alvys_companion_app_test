import 'package:alvys3/src/features/trips/domain/app_trip/app_trip.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trips.freezed.dart';
part 'trips.g.dart';

@freezed
class Trips with _$Trips {
  factory Trips({
    @JsonKey(name: 'Data') List<AppTrip>? data,
    @JsonKey(name: 'ErrorMessage') String? errorMessage,
    @JsonKey(name: 'ErrorCode') int? errorCode,
  }) = _Trips;
  factory Trips.fromJson(Map<String, dynamic> json) => _$TripsFromJson(json);
}
