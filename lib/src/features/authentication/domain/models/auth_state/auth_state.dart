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
    @Default('') String phone,
    @Default('') String verificationCode,
    @Default(false) bool driverLoggedIn,
  }) = _AuthState;
  UserTenant currentUserTenant(String companyCode) =>
      driver!.userTenants.firstWhere((element) => element.companyCode == companyCode);
  factory AuthState.fromJson(Map<String, dynamic> json) => _$AuthStateFromJson(json);
}
