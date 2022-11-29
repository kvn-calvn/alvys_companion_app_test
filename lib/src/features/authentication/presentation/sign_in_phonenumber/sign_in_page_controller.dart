import 'package:alvys3/src/features/authentication/data/data_providers.dart';
import 'package:alvys3/src/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:alvys3/src/features/authentication/domain/models/phonenumber/phonenumber.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInPageController extends StateNotifier<AsyncValue<Phonenumber?>> {
  SignInPageController(this._authRepositoryImpl)
      : super(const AsyncValue.data(null));

  final AuthRepositoryImpl _authRepositoryImpl;

  void loginWithPhoneNumber(String phoneNumber) async {
    state = const AsyncValue.loading();
    final result = await _authRepositoryImpl.loginWithPhoneNumber(phoneNumber);
    if (result.success) {
      state = AsyncValue.data(result.data!);
    } else {
      state = AsyncValue.error(result, StackTrace.current);
    }
  }
}

final signInPageControllerProvider =
    StateNotifierProvider<SignInPageController, AsyncValue<Phonenumber?>>(
        (ref) {
  return SignInPageController(ref.watch(authRepositoryImplProvider));
});
