import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../models/address/address.dart';
import '../../../../../utils/magic_strings.dart';
import 'user_tenant.dart';

part 'driver_user.freezed.dart';
part 'driver_user.g.dart';

@freezed
class DriverUser with _$DriverUser {
  factory DriverUser({
    String? id,
    @JsonKey(name: "UserName") String? userName,
    @JsonKey(name: "Name") String? name,
    @JsonKey(name: "ContractorType") String? contractorType,
    @JsonKey(name: "Email") String? email,
    @JsonKey(name: "DriversLicenceExpirationDate") DateTime? driversLicenceExpirationDate,
    @JsonKey(name: "DriversLicenceState") String? driversLicenceState,
    @JsonKey(name: "DriversLicenceNumber") String? driversLicenceNumber,
    @JsonKey(name: "AppToken") String? appToken,
    @JsonKey(name: "SecondaryEmail") String? secondaryEmail,
    @JsonKey(name: "UserType") String? userType,
    @JsonKey(name: "Phone") String? phone,
    @JsonKey(name: "Address") Address? address,
    @JsonKey(name: "DateCreated") DateTime? dateCreated,
    @JsonKey(name: "DateModified") DateTime? dateModified,
    @Default(true) @JsonKey(name: "FirstLogin") bool firstLogin,
    @Default(false) @JsonKey(name: "IsDeleted") bool isDeleted,
    @Default(<UserTenant>[]) @JsonKey(name: "UserTenants") List<UserTenant> userTenants,
    @JsonKey(name: 'CurrentToken') CurrentToken? currentToken,
  }) = _DriverUser;
  DriverUser._();
  factory DriverUser.fromJson(Map<String, dynamic> json) => _$DriverUserFromJson(json);

  List<UserTenant> get activeTenants => userTenants.where((element) => !(element.isDisabled ?? false)).toList();

  String get companyCodes => activeTenants.map((e) => e.companyCode).removeNulls.join(',');
  String get companyCodesWithSpace => activeTenants.map((e) => e.companyCode).removeNulls.join(', ');

  bool hasContractorType(String contractorType) =>
      userTenants.any((element) => element.contractorType == contractorType);
  bool get isCompanyDriver => hasContractorType(ContractorType.companyDriver);
}

@freezed
class CurrentToken with _$CurrentToken {
  factory CurrentToken({@JsonKey(name: "access_token") required String accessToken}) = _CurrentToken;

  factory CurrentToken.fromJson(Map<String, dynamic> json) => _$CurrentTokenFromJson(json);
}
