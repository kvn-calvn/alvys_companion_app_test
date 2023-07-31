import 'package:alvys3/src/features/trips/domain/model/stop_details/stop_details.dart';
import 'package:alvys3/src/features/trips/domain/repositories/trip_repository.dart';
import 'package:alvys3/src/features/trips/domain/model/trip_details/trip_details.dart';
import 'package:alvys3/src/features/trips/domain/model/trips/trips.dart';
import 'package:alvys3/src/network/api_client.dart';
import 'package:alvys3/src/network/api_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/api_routes.dart';

class TripRepositoryImpl implements TripRepository {
  final ApiClient client;

  TripRepositoryImpl(this.client);

  @override
  Future<ApiResponse<Trips>> getTrips<T>() async {
    var res = await client.getData<T>(ApiRoutes.trips);
    var response = Trips.fromJson(res.data);
    return ApiResponse(
      data: response,
    );
  }

  @override
  Future<ApiResponse<TripDetails>> getTripDetails<T>(String tripId) async {
    var res = await client.getData<T>(ApiRoutes.tripDetails(tripId));
    return ApiResponse(data: TripDetails.fromJson(res.data));
  }

  @override
  Future<ApiResponse<StopDetails>> getStopDetails<T>(String tripId, String stopId) async {
    var res = await client.getData<T>(ApiRoutes.stopdetails(tripId, stopId));
    return ApiResponse(data: StopDetails.fromJson(res.data));
  }

/*
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
*/
}

final tripRepositoryImplProvider = Provider<TripRepositoryImpl>((ref) {
  final client = ref.watch(apiClientProvider);
  return TripRepositoryImpl(client);
});
