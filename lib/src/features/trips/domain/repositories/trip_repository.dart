//import 'package:alvys3/src/features/trips/domain/stop_details/stop_details.dart';
import 'package:alvys3/src/features/trips/domain/model/trip_details/trip_details.dart';
import 'package:alvys3/src/features/trips/domain/model/trips/trips.dart';
import 'package:alvys3/src/network/api_response.dart';

import '../model/stop_details/stop_details.dart';

abstract class TripRepository {
  Future<ApiResponse<Trips>> getTrips<T>();
  Future<ApiResponse<TripDetails>> getTripDetails<T>(String tripId, String companyCode);
  // Future<ApiResponse<StopDetails>> getStopDetails<T>(String tripId, String stopId);
}
