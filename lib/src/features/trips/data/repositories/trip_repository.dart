import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../constants/api_routes.dart';
import '../../../../network/api_client.dart';
import '../../../../utils/magic_strings.dart';
import '../../domain/app_trip/app_trip.dart';

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
}

final tripRepoProvider = Provider<AppTripRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return AppTripRepository(client);
});
