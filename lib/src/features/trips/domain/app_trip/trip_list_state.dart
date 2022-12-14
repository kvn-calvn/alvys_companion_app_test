import 'app_trip.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../utils/extensions.dart';
import 'stop.dart';
part 'trip_list_state.freezed.dart';

@freezed
class TripListState with _$TripListState {
  factory TripListState({
    @Default([]) List<AppTrip> trips,
    String? tripId,
    String? stopId,
  }) = _TripListState;
  const TripListState._();
  List<AppTrip> get deliveredTrips =>
      trips.where((element) => element.status == "Delivered").toList();
  List<AppTrip> get activeTrips =>
      trips.where((element) => element.isTripActive!).toList();
  List<AppTrip> get processingTrips => trips
      .where((element) => element.status!
          .isInStatus(["TONU", "Released", "Invoiced", "Completed", "Queued"]))
      .toList();
  AppTrip get currentTrip =>
      trips.firstWhere((element) => element.id! == tripId);
  Stop get currentStop =>
      currentTrip.stops!.firstWhere((element) => element.stopId == stopId);
}
