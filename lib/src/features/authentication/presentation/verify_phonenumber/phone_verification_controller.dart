import 'package:alvys3/src/features/authentication/data/data_providers.dart';
import 'package:alvys3/src/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:alvys3/src/features/authentication/domain/models/verified/verified.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhoneVerificationPageController
    extends StateNotifier<AsyncValue<Verified?>> {
  PhoneVerificationPageController(this._authRepositoryImpl)
      : super(const AsyncValue.data(null));

  final AuthRepositoryImpl _authRepositoryImpl;
  void verifyPhoneNumber(String phoneNumber, String verificationCode) async {
    state = const AsyncValue.loading();
    final result = await _authRepositoryImpl.verifyPhoneNumber(
        phoneNumber, verificationCode);

    if (result.success) {
      state = AsyncValue.data(result.data!);
    } else {
      state = AsyncValue.error(result.error!, StackTrace.current);
    }
  }
}

final verificationPageController = StateNotifierProvider<
    PhoneVerificationPageController, AsyncValue<Verified?>>((ref) {
  return PhoneVerificationPageController(ref.watch(authRepositoryImplProvider));
});
