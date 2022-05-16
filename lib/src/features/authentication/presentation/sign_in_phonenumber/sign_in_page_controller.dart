import 'package:alvys3/src/features/authentication/data/data_providers.dart';
import 'package:alvys3/src/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:alvys3/src/features/authentication/domain/models/verified/verified.dart';
import 'sign_in_state.dart';
import 'package:alvys3/src/network/api_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInPageController extends StateNotifier<SignInState> {
  SignInPageController(this._authRepositoryImpl)
      : super(const SignInState.initial());

  final AuthRepositoryImpl _authRepositoryImpl;

  void loginWithPhoneNumber(String phoneNumber) async {
    state = const SignInState.loading();
    final result = await _authRepositoryImpl.loginWithPhoneNumber(phoneNumber);
    if (result.success) {
      state = SignInState.success(result.data!);
    } else {
      state = SignInState.error(result.error!);
    }
  }

  Future<ApiResponse<Verified>> verifyPhoneNumber(String verificationCode) {
    throw UnimplementedError();
  }
}

//final signNotifierProvider = StateNotifierProvider<SignInPageController, SignInState>(((ref) => SignInPageController(AuthRepositoryImpl())));

final signInPageControllerProvider =
    StateNotifierProvider<SignInPageController, SignInState>((ref) {
  return SignInPageController(ref.watch(authRepositoryImplProvider));
});
