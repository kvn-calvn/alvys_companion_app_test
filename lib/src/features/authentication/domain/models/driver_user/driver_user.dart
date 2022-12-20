import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'address.dart';
import 'user_tenant.dart';

part 'driver_user.freezed.dart';
part 'driver_user.g.dart';

@freezed
class DriverUser with _$DriverUser {
  factory DriverUser({
    @JsonKey(name: "Id") String? id,
    @JsonKey(name: "UserName") String? userName,
    @JsonKey(name: "Name") String? name,
    @JsonKey(name: "Email") String? email,
    @JsonKey(name: "DriversLicenceExpirationDate")
        DateTime? driversLicenceExpirationDate,
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
    @Default(<UserTenant>[])
    @JsonKey(name: "UserTenants")
        List<UserTenant> userTenants,
  }) = _DriverUser;
  DriverUser._();
  factory DriverUser.fromJson(Map<String, dynamic> json) =>
      _$DriverUserFromJson(json);
  String toStringJson() => jsonEncode(this);
}
