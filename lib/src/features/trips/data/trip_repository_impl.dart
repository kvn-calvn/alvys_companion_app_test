import 'package:alvys3/src/features/trips/data/data_provider.dart';
import 'package:alvys3/src/features/trips/data/trip_repository.dart';
import 'package:alvys3/src/features/trips/data/trips_remote_data_source.dart';
import 'package:alvys3/src/features/trips/domain/stop_details/stop_details.dart';
import 'package:alvys3/src/features/trips/domain/trip_details/trip_details.dart';
import 'package:alvys3/src/features/trips/domain/trips/trips.dart';
import 'package:alvys3/src/network/api_response.dart';
import 'package:alvys3/src/network/error_handler.dart';
import 'package:alvys3/src/network/network_info.dart';

class TripRepositoryImpl implements TripRepository {
  final TripsRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  TripRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<ApiResponse<Trips>> getTrips() async {
    if (await _networkInfo.isConnected) {
      try {
        var response = await _remoteDataSource.getTrips();
        return ApiResponse(
          data: response,
        );
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
  Future<ApiResponse<TripDetails>> getTripDetails(String tripId) async {
    if (await _networkInfo.isConnected) {
      try {
        var response = await _remoteDataSource.getTripDetails(tripId);

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
  Future<ApiResponse<StopDetails>> getStopDetails(
      String tripId, String stopId) async {
    if (await _networkInfo.isConnected) {
      try {
        var response = await _remoteDataSource.getStopDetails(tripId, stopId);

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
