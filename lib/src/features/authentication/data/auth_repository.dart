import 'package:alvys3/src/constants/api_routes.dart';
import 'package:alvys3/src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'package:alvys3/src/network/api_client.dart';
import 'package:alvys3/src/network/api_response.dart';

import '../../../network/network_info.dart';

abstract class AuthRepository<T> {
  Future<ApiResponse<DriverUser>> verifyDriverCode(String phone, String code);
  Future<ApiResponse<String>> signInDriverByPhone(String phone);
  Future<ApiResponse<DriverUser>> getDriverUser(String id);
  Future<ApiResponse<DriverUser>> updateDriverUser();
}

class AvysAuthRepository<T> implements AuthRepository<T> {
  final NetworkInfoImpl network;
  final ApiClient client;
  AvysAuthRepository(this.network, this.client);
  @override
  Future<ApiResponse<DriverUser>> getDriverUser(String id) async {
    if (await network.isConnected) {
      var res = await client.getData(ApiRoutes.userData(id));

      return ApiResponse(
        success: true,
        data: DriverUser.fromJson(res.data),
        error: null,
      );
    }
    return ApiResponse(
      success: false,
      data: null,
      error: "Error occurred",
    );
  }

  @override
  Future<ApiResponse<String>> signInDriverByPhone(
    String phone,
  ) async {
    try {
      var loginRes = await client.getData(ApiRoutes.phoneNumber(phone));
      return ApiResponse(
        success: true,
        data: loginRes.data['Data'].toString(),
        error: null,
      );
    } catch (e) {
      var registerRes = await client.getData(ApiRoutes.registerPhoneNumber(phone));

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
        await client.getData(ApiRoutes.verify(phone, code));
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
