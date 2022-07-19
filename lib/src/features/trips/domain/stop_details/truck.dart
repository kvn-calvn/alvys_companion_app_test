import 'package:freezed_annotation/freezed_annotation.dart';

part 'truck.freezed.dart';
part 'truck.g.dart';

@freezed
class Truck with _$Truck {
  factory Truck({
    @JsonKey(name: 'In') dynamic truckIn,
    @JsonKey(name: 'Out') dynamic out,
  }) = _Truck;

  factory Truck.fromJson(Map<String, dynamic> json) => _$TruckFromJson(json);
}
