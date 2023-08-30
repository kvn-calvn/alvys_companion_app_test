import 'package:freezed_annotation/freezed_annotation.dart';

part 'm_comodity.freezed.dart';
part 'm_comodity.g.dart';

@freezed
class MComodity with _$MComodity {
  factory MComodity({
    @JsonKey(name: 'UnitType') String? unitType,
    @JsonKey(name: 'NumUnits') double? numUnits,
    @JsonKey(name: 'Description') String? description,
    @JsonKey(name: 'NumPieces') double? numPieces,
    @JsonKey(name: 'HandlingType') String? handlingType,
    @JsonKey(name: 'Weight') double? weight,
    @JsonKey(name: 'WeightType') String? weightType,
    @JsonKey(name: 'Hazmat') dynamic hazmat,
    @JsonKey(name: 'Temperature') dynamic temperature,
    @JsonKey(name: 'TemperatureType') dynamic temperatureType,
    @JsonKey(name: 'ServiceType') dynamic serviceType,
    @JsonKey(name: 'Continuous') bool? continuous,
  }) = _MComodity;

  factory MComodity.fromJson(Map<String, dynamic> json) =>
      _$MComodityFromJson(json);
}
