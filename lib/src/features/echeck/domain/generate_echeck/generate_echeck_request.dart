import 'package:freezed_annotation/freezed_annotation.dart';

part 'generate_echeck_request.freezed.dart';
part 'generate_echeck_request.g.dart';

@freezed
class GenerateECheckRequest with _$GenerateECheckRequest {
  factory GenerateECheckRequest({
    @JsonKey(name: 'TripId') required String tripId,
    @JsonKey(name: 'StopId') String? stopId,
    @JsonKey(name: 'TypeId') required String typeId,
    @JsonKey(name: 'Note') required String note,
    @JsonKey(name: 'FirstName') required String firstName,
    @JsonKey(name: 'LastName') required String lastName,
    @JsonKey(name: 'DriverId') required String driverId,
    @JsonKey(name: 'Amount') required double amount,
  }) = _GenerateECheckRequest;

  factory GenerateECheckRequest.fromJson(Map<String, dynamic> json) =>
      _$GenerateECheckRequestFromJson(json);
}
