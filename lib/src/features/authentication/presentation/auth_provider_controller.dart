import 'dart:async';

import 'package:alvys3/src/features/authentication/domain/models/auth_state/auth_state.dart';
import 'package:alvys3/src/utils/extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthProviderNotifier extends AsyncNotifier<AuthState> {
  @override
  FutureOr<AuthState> build() {
    state = AsyncValue.data(AuthState());
    return state.value!;
  }

  setUserTenantCompanyCode(String? companyCode) {
    state = AsyncValue.data(
        state.value!.copyWith(userTenantCompanyCode: companyCode));
  }

  setPhone(String p) =>
      state = AsyncValue.data(state.value!.copyWith(phone: p.numbersOnly));
  setVerificationCode(String v) => state =
      AsyncValue.data(state.value!.copyWith(verificationCode: v.numbersOnly));
}

final authProvider = AsyncNotifierProvider<AuthProviderNotifier, AuthState>(
    AuthProviderNotifier.new);
