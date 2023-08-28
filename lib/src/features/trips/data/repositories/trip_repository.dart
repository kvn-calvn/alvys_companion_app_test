import 'package:alvys3/src/features/trips/domain/model/app_trip/app_trip.dart';
import 'package:alvys3/src/network/api_client.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../constants/api_routes.dart';

abstract class TripRepository {
  Future<List<AppTrip>> getTrips<T>();
  Future<AppTrip> getTripDetails<T>(String tripId, String companyCode);
  // Future<ApiResponse<StopDetails>> getStopDetails<T>(String tripId, String stopId);
}

class AppTripRepository implements TripRepository {
  final ApiClient client;

  AppTripRepository(this.client);

  @override
  Future<List<AppTrip>> getTrips<T>() async {
    var res = await client.getData<T>(ApiRoutes.trips);
    return (res.data as List).map((x) => AppTrip.fromJson(x)).toList();
  }

  @override
  Future<AppTrip> getTripDetails<T>(String tripId, String companyCode) async {
    var storage = const FlutterSecureStorage();
    storage.write(key: StorageKey.companyCode.name, value: companyCode);
    var res = await client.getData<T>(ApiRoutes.tripDetails(tripId));
    return AppTrip.fromJson(res.data);
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

final tripRepoProvider = Provider<AppTripRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return AppTripRepository(client);
});
