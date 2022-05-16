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
        return ApiResponse(
          data: response,
        );
      } catch (error) {
        return ApiResponse(
          success: false,
          error: ErrorHandler.handle(error).failure.message,
        );
        //Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return ApiResponse(
        success: false,
        error: DataSource.NO_INTERNET_CONNECTION.getFailure().message,
      ); //Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<ApiResponse<Verified>> verifyPhoneNumber(String verificationCode) {
    // TODO: implement verifyPhoneNumber
    throw UnimplementedError();
  }
}
