import 'package:alvys3/src/constants/api_routes.dart';
import 'package:alvys3/src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'package:alvys3/src/network/api_client.dart';
import 'package:alvys3/src/network/api_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/auth_provider_controller.dart';

abstract class AuthRepository<T> {
  Future<ApiResponse<DriverUser>> verifyDriverCode(String phone, String code);
  Future<ApiResponse<String>> signInDriverByPhone(String phone);
  Future<ApiResponse<DriverUser>> getDriverUser(String id);
  Future<ApiResponse<DriverUser>> updateDriverUser();
}

class AvysAuthRepository<T> implements AuthRepository<T> {
  final ApiClient client;
  AvysAuthRepository(this.client);
  @override
  Future<ApiResponse<DriverUser>> getDriverUser(String id) async {
    var res = await client.getData<T>(ApiRoutes.userData(id));

    return ApiResponse(
      success: true,
      data: DriverUser.fromJson(res.data),
      error: null,
    );
  }

  @override
  Future<ApiResponse<String>> signInDriverByPhone(
    String phone,
  ) async {
    try {
      var loginRes = await client.getData<T>(ApiRoutes.phoneNumber(phone));
      return ApiResponse(
        success: true,
        data: loginRes.data['Data'].toString(),
        error: null,
      );
    } catch (e) {
      var registerRes = await client.getData<T>(ApiRoutes.registerPhoneNumber(phone));

      return ApiResponse(
        success: true,
        data: registerRes.data['Data'].toString(),
        error: null,
      );
    }
  }

  @override
  Future<ApiResponse<DriverUser>> verifyDriverCode(String phone, String code) async {
    var verifyRes =
        //await ApiClient.singleton.dio.get(Endpoint.verify(phone, code));
        await client.getData<T>(ApiRoutes.verify(phone, code));
    return ApiResponse(
      success: true,
      data: DriverUser.fromJson(verifyRes.data['Data']),
      error: null,
    );
  }

  @override
  Future<ApiResponse<DriverUser>> updateDriverUser() {
    // ignore: todo
    // TODO: implement updateDriverUser
    throw UnimplementedError();
  }
}

final authRepoProvider = Provider<AvysAuthRepository<AuthProviderNotifier>>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AvysAuthRepository(apiClient);
});
