import 'package:alvys3/src/features/trips/domain/stop_details/stop_details.dart';
import 'package:alvys3/src/features/trips/domain/trip_details/trip_details.dart';
import 'package:alvys3/src/features/trips/domain/trips/trips.dart';
import 'package:alvys3/src/network/api_response.dart';

abstract class TripRepository {
  Future<ApiResponse<Trips>> getTrips();
  Future<ApiResponse<TripDetails>> getTripDetails(String tripId);
  Future<ApiResponse<StopDetails>> getStopDetails(String tripId, String stopId);
}
