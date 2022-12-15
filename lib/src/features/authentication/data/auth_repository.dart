import 'package:alvys3/src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'package:alvys3/src/network/api_client.dart';
import 'package:alvys3/src/network/api_response.dart';

abstract class AuthRepository {
  Future<ApiResponse<DriverUser>> verifyDriverCode(String code,
      [Function? onError]);
  Future<ApiResponse<String>> signInDriverByPhone(String phone,
      [Function? onError]);
  Future<ApiResponse<DriverUser>> getDriverUser();
}

class AvysAuthRepository implements AuthRepository {
  @override
  Future<ApiResponse<DriverUser>> getDriverUser() async {
    var res = await ApiClient.singleton.dio.get('path');
    return res.data;
  }

  @override
  Future<ApiResponse<String>> signInDriverByPhone(String phone,
      [Function? onError]) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<DriverUser>> verifyDriverCode(String code,
      [Function? onError]) {
    throw UnimplementedError();
  }
}
