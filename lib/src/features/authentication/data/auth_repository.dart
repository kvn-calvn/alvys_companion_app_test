import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/api_routes.dart';
import '../../../network/http_client.dart';
import '../../../utils/helpers.dart';
import '../domain/models/driver_asset/driver_asset.dart';
import '../domain/models/driver_user/driver_user.dart';
import '../domain/models/update_driver_status_dto/update_driver_status_dto.dart';
import '../domain/models/update_user_dto/update_user_dto.dart';
import '../presentation/auth_provider_controller.dart';

abstract class AuthRepository<T> {
  Future<DriverUser> verifyDriverCode(String phone, String code);
  Future<String> signInDriverByPhone(String phone);
  Future<DriverUser> getDriverUser(String companyCode, String id);
  Future<DriverUser> updateDriverUser<K>(String companyCode, UpdateUserDTO dto);
  Future<DriverAsset> getDriverAsset(String companyCode, String driverId);
  Future<void> updateDriverStatus(String companyCode, UpdateDriverStatusDTO dto);
}

class AvysAuthRepository<T> implements AuthRepository<T> {
  final AlvysHttpClient httpClient;
  AvysAuthRepository(this.httpClient);
  @override
  Future<DriverUser> getDriverUser(String companyCode, String id) async {
    await Helpers.setCompanyCode(companyCode);
    var res = await httpClient.getData<T>(Uri.parse(ApiRoutes.userData(id)));
    return DriverUser.fromJson(res.body.toDecodedJson);
  }

  @override
  Future<String> signInDriverByPhone(
    String phone,
  ) async {
    await httpClient.setTelemetryContext(extraData: {"phone": phone});
    var loginRes = await httpClient.getData<T>(Uri.parse(ApiRoutes.authenticate(phone)));
    return loginRes.body;
  }

  @override
  Future<DriverUser> verifyDriverCode(String phone, String code) async {
    var verifyRes = await httpClient.getData<T>(Uri.parse(ApiRoutes.login(phone, code)));
    var user = DriverUser.fromJson(verifyRes.body.toDecodedJson);
    await httpClient.setTelemetryContext(user: user);
    return user;
  }

  @override
  Future<DriverUser> updateDriverUser<K>(String companyCode, UpdateUserDTO dto) async {
    await Helpers.setCompanyCode(companyCode);
    var res = await httpClient.putData<K>(ApiRoutes.driverInfo, body: dto.toJson().removeNulls.toJsonEncodedString);
    return DriverUser.fromJson(res.body.toDecodedJson);
  }

  @override
  Future<DriverAsset> getDriverAsset(String companyCode, String driverId) async {
    await Helpers.setCompanyCode(companyCode);
    var res = await httpClient.getData<T>(ApiRoutes.driverAsset(driverId));
    return DriverAsset.fromJson(res.body.toDecodedJson);
  }

  @override
  Future<void> updateDriverStatus(String companyCode, UpdateDriverStatusDTO dto) {
    return httpClient.patchData<T>(ApiRoutes.driverStatus, body: dto.toJson().toJsonEncodedString);
  }
}

final authRepoProvider = Provider<AvysAuthRepository<AuthProviderNotifier>>(
    (ref) => AvysAuthRepository<AuthProviderNotifier>(ref.read(httpClientProvider)));
