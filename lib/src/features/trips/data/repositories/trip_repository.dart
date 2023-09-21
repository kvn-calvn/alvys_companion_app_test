import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/api_routes.dart';
import '../../../../network/http_client.dart';
import '../../../../utils/helpers.dart';
import '../../domain/app_trip/app_trip.dart';
import '../../domain/app_trip/stop.dart';
import '../../domain/update_stop_time_record/update_stop_time_record.dart';

abstract class TripRepository {
  Future<List<AppTrip>> getTrips<T>();
  Future<AppTrip> getTripDetails<T>(String tripId, String companyCode);
  Future<Stop> updateStopTimeRecord<T>(String companyCode, String tripId, String stopId, UpdateStopTimeRecord record);
}

class AppTripRepository implements TripRepository {
  final AlvysHttpClient httpClient;
  AppTripRepository(this.httpClient);

  @override
  Future<List<AppTrip>> getTrips<T>() async {
    var res = await httpClient.getData<T>(Uri.parse(ApiRoutes.trips));
    return (res.body.toDecodedJson as List).map((x) => AppTrip.fromJson(x)).toList();
  }

  @override
  Future<AppTrip> getTripDetails<T>(String tripId, String companyCode) async {
    await Helpers.setCompanyCode(companyCode);
    var res = await httpClient.getData<T>(Uri.parse(ApiRoutes.tripDetails(tripId)));
    return AppTrip.fromJson(res.body.toDecodedJson);
  }

  @override
  Future<Stop> updateStopTimeRecord<T>(
      String companyCode, String tripId, String stopId, UpdateStopTimeRecord record) async {
    await Helpers.setCompanyCode(companyCode);
    print(record.toJson().toJsonEncodedString);
    var res = await httpClient.putData<T>(
      Uri.parse(ApiRoutes.timeStopRecord(tripId, stopId)),
      body: record.toJson().toJsonEncodedString,
    );
    return Stop.fromJson(res.body.toDecodedJson);
  }
}

final tripRepoProvider = Provider<AppTripRepository>((ref) {
  final httpClient = ref.read(httpClientProvider);
  return AppTripRepository(httpClient);
});
