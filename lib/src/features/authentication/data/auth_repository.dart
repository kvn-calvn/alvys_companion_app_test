import 'package:alvys3/src/constants/api_routes.dart';
import 'package:alvys3/src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'package:alvys3/src/network/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/auth_provider_controller.dart';

abstract class AuthRepository<T> {
  Future<DriverUser> verifyDriverCode(String phone, String code);
  Future<String> signInDriverByPhone(String phone);
  Future<DriverUser> getDriverUser(String id);
  Future<DriverUser> updateDriverUser();
}

class AvysAuthRepository<T> implements AuthRepository<T> {
  final ApiClient client;
  AvysAuthRepository(this.client);
  @override
  Future<DriverUser> getDriverUser(String id) async {
    var res = await client.getData<T>(ApiRoutes.userData(id));
    return DriverUser.fromJson(res.data);
  }

  @override
  Future<String> signInDriverByPhone(
    String phone,
  ) async {
    var loginRes = await client.getData<T>(ApiRoutes.authenticate(phone));
    return loginRes.data.toString();
  }

  @override
  Future<DriverUser> verifyDriverCode(String phone, String code) async {
    var verifyRes =
        //await ApiClient.singleton.dio.get(Endpoint.verify(phone, code));
        await client.getData<T>(ApiRoutes.login(phone, code));
    return DriverUser.fromJson(verifyRes.data);
  }

  @override
  Future<DriverUser> updateDriverUser() {
    // ignore: todo
    // TODO: implement updateDriverUser
    throw UnimplementedError();
  }
}

final authRepoProvider = Provider<AvysAuthRepository<AuthProviderNotifier>>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AvysAuthRepository(apiClient);
});
