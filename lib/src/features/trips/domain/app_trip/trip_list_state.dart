import '../../../../utils/magic_strings.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';

import 'app_trip.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'stop.dart';
part 'trip_list_state.freezed.dart';

@freezed
class TripListState with _$TripListState {
  factory TripListState({
    @Default([]) List<AppTrip> trips,
    String? loadingStopId,
    @Default(true) bool checkIn,
  }) = _TripListState;
  const TripListState._();
  List<AppTrip> get deliveredTrips {
    return trips
        .where((element) => element.status.equalsIgnoreCase(TripStatus.delivered))
        .orderBy((element) => element.deliveryDate, OrderDirection.desc)
        .toList();
  }

  List<AppTrip> get activeTrips {
    return trips
        .where((element) => element.status!.inIgnoreCase([TripStatus.inTransit, TripStatus.dispatched]))
        .orderBy((element) => element.deliveryDate, OrderDirection.asc)
        .toList();
  }

  List<AppTrip> get processingTrips {
    return trips
        .where((element) => element.status!.inIgnoreCase([
              TripStatus.tonu,
              TripStatus.released,
              TripStatus.invoiced,
              TripStatus.completed,
              TripStatus.queued,
            ]))
        .orderBy((element) => element.deliveryDate, OrderDirection.desc)
        .toList();
  }

  // int sortDates(DateTime? a, DateTime? b) {
  //   return a.isAfterNull(b) ? 1 : -1;
  // }

  AppTrip getTrip(String tripId) =>
      trips.firstWhere((element) => element.id! == tripId, orElse: () => AppTrip(id: '-', tripNumber: '...'));
  AppTrip? tryGetTrip(String tripId) => trips.firstWhereOrNull((e) => e.id! == tripId);
  Stop getStop(String tripId, String stopId) => getTrip(tripId).stops.firstWhere((element) => element.stopId == stopId);
  Stop? tryGetStop(String tripId, String? stopId) => stopId.isNullOrEmptyWhiteSpace
      ? null
      : tryGetTrip(tripId)?.stops.firstWhereOrNull((element) => element.stopId == stopId);

  AppTrip get trackingTrip =>
      activeTrips.firstWhereOrNull((e) => e.status.equalsIgnoreCase(TripStatus.inTransit)) ??
      activeTrips.firstWhereOrNull((e) => e.status.equalsIgnoreCase(TripStatus.inTransit)) ??
      activeTrips.first;
  bool checkInLoading(Stop stop) =>
      loadingStopId != null ? stop.stopId.equalsIgnoreCase(loadingStopId!) && checkIn : false;
  bool checkOutLoading(Stop stop) =>
      loadingStopId != null ? stop.stopId.equalsIgnoreCase(loadingStopId!) && !checkIn : false;
}
