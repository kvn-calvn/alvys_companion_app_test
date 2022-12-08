import 'package:alvys3/src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'package:alvys3/src/features/authentication/domain/models/driver_user/user_tenant.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
  }) = _AuthState;
  UserTenant get currentUserTenant => driver!.userTenants
      .firstWhere((element) => element.companyCode == userTenantCompanyCode);
  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);
}
