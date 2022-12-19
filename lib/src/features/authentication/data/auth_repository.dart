import 'package:alvys3/src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'package:alvys3/src/network/api_client.dart';
import 'package:alvys3/src/network/api_response.dart';
import 'package:alvys3/src/network/client_error/client_error.dart';
import 'package:alvys3/src/network/endpoints.dart';
import 'package:alvys3/src/routing/error_page.dart';
import 'package:alvys3/src/utils/exceptions.dart';

import '../../../network/network_info.dart';

abstract class AuthRepository {
  Future<ApiResponse<DriverUser>> verifyDriverCode(String phone, String code,
      [Function? onError]);
  Future<ApiResponse<String>> signInDriverByPhone(String phone,
      [Function? onError]);
  Future<ApiResponse<DriverUser>> getDriverUser(String id);
  Future<ApiResponse<DriverUser>> updateDriverUser();
}

class AvysAuthRepository implements AuthRepository {
  final NetworkInfoImpl network;

  AvysAuthRepository(this.network);
  @override
  Future<ApiResponse<DriverUser>> getDriverUser(String id) async {
    if (await network.isConnected) {
      var res = await ApiClient.singleton.dio.get(Endpoint.driverUserData(id));
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
  Future<ApiResponse<String>> signInDriverByPhone(String phone,
      [Function? onError]) async {
    var loginRes =
        await ApiClient.singleton.dio.get(Endpoint.loginByPhone(phone));

    if (loginRes.statusCode != 200) {
      var registerRes =
          await ApiClient.singleton.dio.get(Endpoint.registerByPhone(phone));
      switch (registerRes.statusCode) {
        case 200:
          return ApiResponse(
            success: true,
            data: registerRes.data['Data'].toString(),
            error: null,
          );
        case 400:
          ErrorFunctionHandler.instance.onError = onError;
          throw ClientException(registerRes.data);
        case 417:
          ErrorFunctionHandler.instance.onError = onError;
          throw ClientException(ClientError(
            title: "Failed to find user",
            content: registerRes.data['ErrorMessage'].toString(),
          ));
        default:
          throw ClientException(ClientError(
            title: "Error",
            content: 'An error has occured, try again',
          ));
      }
    }

    return ApiResponse(
      success: true,
      data: loginRes.data['Data'].toString(),
      error: null,
    );
  }

  @override
  Future<ApiResponse<DriverUser>> verifyDriverCode(String phone, String code,
      [Function? onError]) async {
    var verifyRes =
        await ApiClient.singleton.dio.get(Endpoint.verify(phone, code));

    switch (verifyRes.statusCode) {
      case 200:
        return ApiResponse(
          success: true,
          data: DriverUser.fromJson(verifyRes.data['Data']),
          error: null,
        );
      case 400:
        ErrorFunctionHandler.instance.onError = onError;
        throw ClientException(verifyRes.data);
      case 417:
        ErrorFunctionHandler.instance.onError = onError;
        throw ClientException(ClientError(
          title: "Failed to find user",
          content: verifyRes.data['ErrorMessage'].toString(),
        ));
      default:
        throw ClientException(ClientError(
          title: "Error",
          content: 'An error has occured, try again',
        ));
    }
  }

  @override
  Future<ApiResponse<DriverUser>> updateDriverUser() {
    // TODO: implement updateDriverUser
    throw UnimplementedError();
  }
}
