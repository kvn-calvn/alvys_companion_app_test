import 'dart:async';
import 'package:alvys3/src/constants/api_routes.dart';
import 'package:alvys3/src/network/api_client.dart';
import 'package:alvys3/src/utils/utils.dart';
import 'package:alvys3/src/features/authentication/domain/models/phonenumber/phonenumber.dart';
import 'package:alvys3/src/features/authentication/domain/models/verified/verified.dart';

abstract class AuthRemoteDataSource {
  Future<Phonenumber> loginWithPhoneNumber(String phoneNumber);
  Future<Verified> verifyPhoneNumber(
      String phoneNumber, String verificationCode);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;
  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Phonenumber> loginWithPhoneNumber(String phoneNumber) async {
    var base64PhoneNumber = Utils.base64String(phoneNumber);

    var res =
        await _apiClient.dio.get('${ApiRoutes.phoneNumber}/$base64PhoneNumber');

    return Phonenumber.fromJson(res.data);
  }

  @override
  Future<Verified> verifyPhoneNumber(
      String phoneNumber, String verificationCode) async {
    var base64VerificationCode = Utils.base64String(verificationCode);
    var base64PhoneNumber = Utils.base64String(phoneNumber);

    var res = await _apiClient.dio
        .get('${ApiRoutes.verify}/$base64PhoneNumber/$base64VerificationCode');
    return Verified.fromJson(res.data);
  }
}
