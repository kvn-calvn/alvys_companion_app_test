import 'package:alvys3/src/network/api_response.dart';
import 'package:alvys3/src/network/error_handler.dart';
import 'package:alvys3/src/network/network_info.dart';
import 'package:alvys3/src/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:alvys3/src/features/authentication/domain/models/verified/verified.dart';
import 'package:alvys3/src/features/authentication/domain/models/phonenumber/phonenumber.dart';
import 'package:alvys3/src/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<ApiResponse<Phonenumber>> loginWithPhoneNumber(
      String phoneNumber) async {
    if (await _networkInfo.isConnected) {
      try {
        var response =
            await _remoteDataSource.loginWithPhoneNumber(phoneNumber);

        if (response.errorCode == 0) {
          return ApiResponse(
            data: response,
          );
        } else if (response.errorCode == 9007) {
          return ApiResponse(success: false, error: "Account not found.");
        } else {
          return ApiResponse(
            success: false,
            error: DataSource.DEFAULT.getFailure().message,
          );
        }
      } catch (error) {
        return ApiResponse(
          success: false,
          error: ErrorHandler.handle(error).failure.message,
        );
      }
    } else {
      return ApiResponse(
        success: false,
        error: DataSource.NO_INTERNET_CONNECTION.getFailure().message,
      );
    }
  }

  @override
  Future<ApiResponse<Verified>> verifyPhoneNumber(
      String phoneNumber, String verificationCode) async {
    if (await _networkInfo.isConnected) {
      try {
        var response = await _remoteDataSource.verifyPhoneNumber(
            phoneNumber, verificationCode);

        return ApiResponse(data: response);
      } catch (error) {
        return ApiResponse(
          success: false,
          error: ErrorHandler.handle(error).failure.message,
        );
      }
    } else {
      return ApiResponse(
        success: false,
        error: DataSource.NO_INTERNET_CONNECTION.getFailure().message,
      );
    }
  }
}
