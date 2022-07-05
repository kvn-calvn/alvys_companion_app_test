import 'package:freezed_annotation/freezed_annotation.dart';

part 'datum.freezed.dart';
part 'datum.g.dart';

@freezed
class Datum with _$Datum {
  factory Datum({
    @JsonKey(name: 'Id') String? id,
    @JsonKey(name: 'FirstStopAddress') String? firstStopAddress,
    @JsonKey(name: 'LastStopAddress') String? lastStopAddress,
    @JsonKey(name: 'Equipment') String? equipment,
    @JsonKey(name: 'EquipmentLength') String? equipmentLength,
    @JsonKey(name: 'TripNumber') String? tripNumber,
    @JsonKey(name: 'Status') String? status,
    @JsonKey(name: 'TripValue') double? tripValue,
    @JsonKey(name: 'TotalMiles') double? totalMiles,
    @JsonKey(name: 'EmptyMiles') double? emptyMiles,
    @JsonKey(name: 'TotalWeight') double? totalWeight,
    @JsonKey(name: 'Temperature') double? temperature,
    @JsonKey(name: 'StopCount') int? stopCount,
    @JsonKey(name: 'PickupDate') DateTime? pickupDate,
    @JsonKey(name: 'DeliveryDate') DateTime? deliveryDate,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}
