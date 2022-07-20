import 'package:alvys3/src/features/echeck/data/datasources/echeck_remote_data_source.dart';
import 'package:alvys3/src/features/echeck/data/repositories/echeck_repository.dart';
import 'package:alvys3/src/network/api_response.dart';
import 'package:alvys3/src/features/echeck/domain/echeck_query/echeck_query.dart';
import 'package:alvys3/src/features/echeck/domain/echeck_list/echeck_list.dart';
import 'package:alvys3/src/network/error_handler.dart';
import 'package:alvys3/src/network/network_info.dart';

class EcheckRepositoryImpl implements EcheckRepository {
  final EcheckRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  EcheckRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<ApiResponse<EcheckList>> getEchecksByTripId(String tripId) async {
    if (await _networkInfo.isConnected) {
      try {
        var response = await _remoteDataSource.getEchecksByTripId(tripId);

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

  @override
  Future<ApiResponse<EcheckQuery>> queryExpressNumber(
      String expressCheckNumber) async {
    if (await _networkInfo.isConnected) {
      try {
        var response =
            await _remoteDataSource.queryExpressNumber(expressCheckNumber);

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
