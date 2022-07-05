import 'package:freezed_annotation/freezed_annotation.dart';

import 'mini_stop.dart';

part 'data.freezed.dart';
part 'data.g.dart';

@freezed
class Data with _$Data {
  factory Data({
    @JsonKey(name: 'Id') String? id,
    @JsonKey(name: 'Equipment') String? equipment,
    @JsonKey(name: 'EquipmentLength') String? equipmentLength,
    @JsonKey(name: 'TripNumber') String? tripNumber,
    @JsonKey(name: 'Status') String? status,
    @JsonKey(name: 'TruckNum') String? truckNum,
    @JsonKey(name: 'TrailerNum') String? trailerNum,
    @JsonKey(name: 'GeneralInstructions') String? generalInstructions,
    @JsonKey(name: 'TotalMiles') double? totalMiles,
    @JsonKey(name: 'PaidMiles') double? paidMiles,
    @JsonKey(name: 'EmptyMiles') double? emptyMiles,
    @JsonKey(name: 'TotalWeight') double? totalWeight,
    @JsonKey(name: 'Temperature') double? temperature,
    @JsonKey(name: 'MiniStops') List<MiniStop>? miniStops,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}
