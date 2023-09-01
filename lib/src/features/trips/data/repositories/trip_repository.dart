import 'dart:io';

import 'package:alvys3/src/network/http_client.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../constants/api_routes.dart';
import '../../../../network/api_client.dart';
import '../../../../utils/magic_strings.dart';
import '../../domain/app_trip/app_trip.dart';
import '../../domain/app_trip/stop.dart';
import '../../domain/update_stop_time_record/update_stop_time_record.dart';

abstract class TripRepository {
  Future<List<AppTrip>> getTrips<T>();
  Future<AppTrip> getTripDetails<T>(String tripId, String companyCode);
  Future<Stop> updateStopTimeRecord<T>(String companyCode, String tripId, String stopId, UpdateStopTimeRecord record);
  // Future<ApiResponse<StopDetails>> getStopDetails<T>(String tripId, String stopId);
}

class AppTripRepository implements TripRepository {
  final ApiClient client;
  final AlvysHttpClient httpClient;
  AppTripRepository(this.client, this.httpClient);

  @override
  Future<List<AppTrip>> getTrips<T>() async {
    var res = await client.getData<T>(ApiRoutes.trips);
    return (res.data as List).map((x) => AppTrip.fromJson(x)).toList();
  }

  @override
  Future<AppTrip> getTripDetails<T>(String tripId, String companyCode) async {
    var storage = const FlutterSecureStorage();
    await storage.write(key: StorageKey.companyCode.name, value: companyCode);
    var res = await httpClient.getData<T>(Uri.parse(ApiRoutes.tripDetails(tripId)));
    return AppTrip.fromJson(res.body.toDecodedJson);
  }

  @override
  Future<Stop> updateStopTimeRecord<T>(
      String companyCode, String tripId, String stopId, UpdateStopTimeRecord record) async {
    var storage = const FlutterSecureStorage();
    await storage.write(key: StorageKey.companyCode.name, value: companyCode);
    var res = await httpClient.putData<T>(
      Uri.parse(ApiRoutes.timeStopRecord(tripId, stopId)),
      body: record.toJson().toJsonEncodedString,
    );
    return Stop.fromJson(res.body.toDecodedJson);
  }
}

final tripRepoProvider = Provider<AppTripRepository>((ref) {
  final httpClient = ref.read(httpClientProvider);
  final client = ref.read(apiClientProvider);
  return AppTripRepository(client, httpClient);
});
