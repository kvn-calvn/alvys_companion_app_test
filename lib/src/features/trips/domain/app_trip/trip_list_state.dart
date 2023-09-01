import 'package:alvys3/src/utils/extensions.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
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
  List<AppTrip> get deliveredTrips => trips.where((element) => element.status == TripStatus.delivered).toList();
  List<AppTrip> get activeTrips => trips.where((element) => element.isTripActive!).toList();
  List<AppTrip> get processingTrips => trips
      .where((element) => element.status!.isInStatus([
            TripStatus.tonu,
            TripStatus.released,
            TripStatus.invoiced,
            TripStatus.completed,
            TripStatus.queued,
          ]))
      .toList();

  AppTrip getTrip(String tripId) =>
      trips.firstWhere((element) => element.id! == tripId, orElse: () => AppTrip(id: '-', tripNumber: '...'));
  AppTrip? getTripOrNull(String tripId) => trips.firstWhereOrNull((e) => e.id! == tripId);
  Stop getStop(String tripId, String stopId) =>
      getTrip(tripId).stops!.firstWhere((element) => element.stopId == stopId);
}
