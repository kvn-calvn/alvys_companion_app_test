import 'dart:async';
import 'package:alvys3/src/constants/api_routes.dart';
import 'package:alvys3/src/features/trips/domain/stop_details/stop_details.dart';
import 'package:alvys3/src/features/trips/domain/trip_details/trip_details.dart';
import 'package:alvys3/src/features/trips/domain/trips/trips.dart';
import 'package:alvys3/src/network/api_client.dart';

abstract class TripsRemoteDataSource {
  Future<Trips> getTrips();
  Future<TripDetails> getTripDetails(String tripId);
  Future<StopDetails> getStopDetails(String tripId, String stopId);
}

class TripsRemoteDataSourceImpl implements TripsRemoteDataSource {
  final ApiClient _apiClient;
  TripsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Trips> getTrips() async {
    var res = await _apiClient.dio.get(ApiRoutes.trips);
    return Trips.fromJson(res.data);
  }

  @override
  Future<TripDetails> getTripDetails(String tripId) async {
    var res = await _apiClient.dio.get(ApiRoutes.tripdetails + tripId);
    return TripDetails.fromJson(res.data);
  }

  @override
  Future<StopDetails> getStopDetails(String stopId, String tripId) async {
    var res =
        await _apiClient.dio.get(ApiRoutes.stopdetails + tripId + '/' + stopId);
    return StopDetails.fromJson(res.data);
  }
}
