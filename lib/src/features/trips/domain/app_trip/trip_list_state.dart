import '../../../../utils/extensions.dart';

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
    var res = trips.where((element) => element.status == TripStatus.delivered).toList();
    res.sort((a, b) => (a.deliveryDate).isAfterNull(b.deliveryDate) ? 1 : -1);
    return res;
  }

  List<AppTrip> get activeTrips {
    var res = trips.where((element) => element.isTripActive!).toList();
    res.sort((a, b) => a.deliveryDate.isAfterNull(b.deliveryDate) ? 1 : -1);
    return res;
  }

  List<AppTrip> get processingTrips {
    var res = trips
        .where((element) => element.status!.inIgnoreCase([
              TripStatus.tonu,
              TripStatus.released,
              TripStatus.invoiced,
              TripStatus.completed,
              TripStatus.queued,
            ]))
        .toList();
    res.sort((a, b) => (a.deliveryDate).isAfterNull(b.deliveryDate) ? 1 : -1);
    return res;
  }

  AppTrip getTrip(String tripId) =>
      trips.firstWhere((element) => element.id! == tripId, orElse: () => AppTrip(id: '-', tripNumber: '...'));
  AppTrip? tryGetTrip(String tripId) => trips.firstWhereOrNull((e) => e.id! == tripId);
  Stop getStop(String tripId, String stopId) => getTrip(tripId).stops.firstWhere((element) => element.stopId == stopId);
  Stop? tryGetStop(String tripId, String stopId) =>
      tryGetTrip(tripId)?.stops.firstWhereOrNull((element) => element.stopId == stopId);
}
