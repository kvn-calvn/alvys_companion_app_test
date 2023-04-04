import 'package:alvys3/src/constants/api_routes.dart';
import 'package:alvys3/src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'package:alvys3/src/network/api_client.dart';
import 'package:alvys3/src/network/api_response.dart';
import 'package:alvys3/src/network/client_error/client_error.dart';
import 'package:alvys3/src/utils/exceptions.dart';

import '../../../network/network_info.dart';

abstract class AuthRepository<T> {
  Future<ApiResponse<DriverUser>> verifyDriverCode(String phone, String code);
  Future<ApiResponse<String>> signInDriverByPhone(String phone);
  Future<ApiResponse<DriverUser>> getDriverUser(String id);
  Future<ApiResponse<DriverUser>> updateDriverUser();
}

class AvysAuthRepository<T> implements AuthRepository<T> {
  final NetworkInfoImpl network;

  AvysAuthRepository(this.network);
  @override
  Future<ApiResponse<DriverUser>> getDriverUser(String id) async {
    if (await network.isConnected) {
      var res = await ApiClient.singleton.dio.get(ApiRoutes.userData(id));
      if (res.statusCode == 200) {
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
    var loginRes =
        //await ApiClient.singleton.dio.get(Endpoint.loginByPhone(phone));
        await ApiClient.singleton.dio.get(ApiRoutes.phoneNumber(phone));

    if (loginRes.statusCode != 200) {
      var registerRes = await ApiClient.singleton.dio
          .get(ApiRoutes.registerPhoneNumber(phone));
      switch (registerRes.statusCode) {
        case 200:
          return ApiResponse(
            success: true,
            data: registerRes.data['Data'].toString(),
            error: null,
          );
        case 400:
          throw AlvysClientException(registerRes.data, T);
        case 417:
          throw AlvysClientException(
              ClientError(
                title: "Account not found",
                content: registerRes.data['ErrorMessage'].toString(),
              ),
              T);
        default:
          throw AlvysClientException(
              ClientError(
                title: "An error has occured",
                content: 'An error has occured, try again',
              ),
              T);
      }
    }

    return ApiResponse(
      success: true,
      data: loginRes.data['Data'].toString(),
      error: null,
    );
  }

  @override
  Future<ApiResponse<DriverUser>> verifyDriverCode(
      String phone, String code) async {
    var verifyRes =
        //await ApiClient.singleton.dio.get(Endpoint.verify(phone, code));
        await ApiClient.singleton.dio.get(ApiRoutes.verify(phone, code));

    switch (verifyRes.statusCode) {
      case 200:
        return ApiResponse(
          success: true,
          data: DriverUser.fromJson(verifyRes.data['Data']),
          error: null,
        );
      case 400:
        throw AlvysClientException(verifyRes.data, T);
      case 417:
        throw AlvysClientException(
            ClientError(
              title: "Failed to find user",
              content: verifyRes.data['ErrorMessage'].toString(),
            ),
            T);
      default:
        throw AlvysClientException(
            ClientError(
              title: "Error",
              content: 'An error has occured, try again',
            ),
            T);
    }
  }

  @override
  Future<ApiResponse<DriverUser>> updateDriverUser() {
    // ignore: todo
    // TODO: implement updateDriverUser
    throw UnimplementedError();
  }
}
