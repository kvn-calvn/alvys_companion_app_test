import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';

import '../../../../../utils/magic_strings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../driver_user/driver_user.dart';
import '../driver_user/user_tenant.dart';

part 'auth_state.freezed.dart';
part 'auth_state.g.dart';

@freezed
class AuthState with _$AuthState {
  const AuthState._();
  factory AuthState({
    DriverUser? driver,
    String? userTenantCompanyCode,
    String? driverStatus,
    @Default('') String phone,
    @Default('') String verificationCode,
    @Default(false) bool driverLoggedIn,
  }) = _AuthState;

  UserTenant? tryGetUserTenant(String companyCode) =>
      driver!.userTenants.firstWhereOrNull((element) => element.companyCode == companyCode);
  factory AuthState.fromJson(Map<String, dynamic> json) => _$AuthStateFromJson(json);

  bool shouldShowEcheckButton(String companyCode) =>
      (tryGetUserTenant(companyCode)?.permissions.containsIgnoreCase(UserPermissions.generateEcheck) ?? false);

  bool shouldShowCancelEcheckButton(String companyCode, String? echeckUserId) {
    return (tryGetUserTenant(companyCode)?.permissions.containsIgnoreCase(UserPermissions.cancelEcheck) ?? false) &&
        driver?.id == (echeckUserId ?? "");
  }

  bool shouldShowOOPRate(String companyCode) =>
      tryGetUserTenant(companyCode)?.permissions.containsIgnoreCase(UserPermissions.viewOOPRate) ?? false;

  bool shouldShowPayableAmount(String companyCode) =>
      tryGetUserTenant(companyCode)?.permissions.containsIgnoreCase(UserPermissions.viewPayableAmount) ?? false;

  bool shouldShowCarrierConfirmations(String companyCode) =>
      tryGetUserTenant(companyCode)?.permissions.containsIgnoreCase(UserPermissions.viewCarrierRateConfirmation) ??
      false;

  bool shouldShowCustomerRateConfirmations(String companyCode) =>
      tryGetUserTenant(companyCode)?.permissions.containsIgnoreCase(UserPermissions.viewCustomerRateConfirmation) ??
      false;

  bool get canViewPaystubs => driver!.userTenants
      .where((element) => element.companyOwnedAsset ?? false)
      .expand((element) => element.permissions)
      .containsIgnoreCase(UserPermissions.viewPaystubs);
}
