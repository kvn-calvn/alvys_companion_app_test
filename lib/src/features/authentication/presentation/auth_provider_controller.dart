import 'dart:async';

import 'package:alvys3/src/features/authentication/domain/models/auth_state/auth_state.dart';
import 'package:alvys3/src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'package:alvys3/src/utils/extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthProviderNotifier extends AsyncNotifier<AuthState> {
  final DriverUser? driver;

  AuthProviderNotifier({this.driver});
  @override
  FutureOr<AuthState> build() {
    state = AsyncValue.data(
        AuthState(driver: driver, driverLoggedIn: driver != null));
    return state.value!;
  }

  void setUserTenantCompanyCode(String? companyCode) {
    state = AsyncValue.data(
        state.value!.copyWith(userTenantCompanyCode: companyCode));
  }

  void setPhone(String p) {
    state = AsyncValue.data(state.value!.copyWith(phone: p.numbersOnly));
  }

  void setVerificationCode(String v) {
    state =
        AsyncValue.data(state.value!.copyWith(verificationCode: v.numbersOnly));
  }

  void setDriverUserData(DriverUser? data) {
    state = AsyncValue.data(
        state.value!.copyWith(driver: data, driverLoggedIn: driver != null));
  }

  void logOutDriver() {
    state = AsyncValue.data(state.value!
        .copyWith(phone: '', verificationCode: '', driverLoggedIn: false));
  }
}

var authProvider = AsyncNotifierProvider<AuthProviderNotifier, AuthState>(
    () => AuthProviderNotifier(driver: null));
