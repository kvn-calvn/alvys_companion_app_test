import 'package:alvys3/src/features/authentication/presentation/auth_provider_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/exceptions.dart';
import '../domain/models/auth_state/auth_state.dart';

extension AuthStateExtension on AsyncValue<AuthState> {
  AuthState get authValue {
    final value = this.value;
    if (value == null) {
      throw AlvysUnauthorizedException(AuthProviderNotifier);
    }
    return value;
  }
}
