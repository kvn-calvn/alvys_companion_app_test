import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_asset.freezed.dart';
part 'driver_asset.g.dart';

@freezed
class DriverAsset with _$DriverAsset {
  factory DriverAsset({
    required String id,
    @JsonKey(name: 'Status') required String status,
    @JsonKey(name: 'CompanyCode') required String companyCode,
    @JsonKey(name: 'Phone') required String phone,
    @JsonKey(name: 'UserId') String? userId,
  }) = _DriverAsset;

  factory DriverAsset.fromJson(Map<String, dynamic> json) => _$DriverAssetFromJson(json);
}
