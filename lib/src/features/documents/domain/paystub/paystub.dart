import 'package:alvys3/src/constants/api_routes.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'paystub.freezed.dart';
part 'paystub.g.dart';

@freezed
class Paystub with _$Paystub {
  factory Paystub({
    @JsonKey(name: 'Id') String? id,
    @JsonKey(name: 'CompanyCode') String? companyCode,
    @JsonKey(name: 'FileName') String? fileName,
    @JsonKey(name: 'TenantCompanyName') String? tenantCompanyName,
    @JsonKey(name: 'DatePaid') DateTime? datePaid,
  }) = _Paystub;
  Paystub._();
  String get link =>
      '${ApiRoutes.storageUrl}${companyCode!.toLowerCase()}/$fileName';
  factory Paystub.fromJson(Map<String, dynamic> json) =>
      _$PaystubFromJson(json);
}
