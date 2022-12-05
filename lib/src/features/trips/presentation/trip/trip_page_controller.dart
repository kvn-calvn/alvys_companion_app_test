import 'dart:async';

import 'package:alvys3/src/features/trips/data/data_provider.dart';
import 'package:alvys3/src/features/trips/data/trip_repository_impl.dart';
import 'package:alvys3/src/features/trips/domain/app_trip/app_trip.dart';
import 'package:alvys3/src/features/trips/domain/app_trip/trip_list_state.dart';
import 'package:alvys3/src/features/trips/domain/trips/trips.dart';
import 'package:alvys3/src/network/api_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../utils/extensions.dart';

final getTripsProvider = FutureProvider<ApiResponse<Trips?>>((ref) async {
  final trips = await ref.read(tripRepositoryImplProvider).getTrips();
  return trips;
});

class TripPageController extends AutoDisposeAsyncNotifier<TripListState> {
  late TripRepositoryImpl _tripRepositoryImpl;

  Future<void> getTrips() async {
    state = const AsyncValue.loading();
    final result = await _tripRepositoryImpl.getTrips();
    if (result.success) {
      var dataToGet = result.data!.data.toListNotNull();
      state = AsyncValue.data(state.value!.copyWith(trips: dataToGet));
    } else {
      state = AsyncValue.error(result.error!, StackTrace.current);
    }
  }

  void setCurrentTrip(String tripId) =>
      state = AsyncValue.data(state.value!.copyWith(tripId: tripId));
  void setCurrentStop(String stopId) =>
      state = AsyncValue.data(state.value!.copyWith(stopId: stopId));

  Future<void> refreshTrips() async {
    final result = await _tripRepositoryImpl.getTrips();
    if (result.success) {
      var dataToGet = result.data!.data.toListNotNull();
      state = AsyncValue.data(state.value!.copyWith(trips: dataToGet));
    }
  }

  Future<void> refreshCurrentTrip() async {
    final result =
        await _tripRepositoryImpl.getTripDetails(state.value!.tripId!);
    if (result.success) {
      var dataToGet = result.data!.data;
      int index = state.value!.trips
          .indexWhere((element) => element.id == dataToGet!.id!);
      var trips = List<AppTrip>.from(state.value!.trips);
      trips[index] = dataToGet!;
      state = AsyncValue.data(state.value!.copyWith(trips: trips));
    }
  }

  @override
  FutureOr<TripListState> build() async {
    _tripRepositoryImpl = ref.read(tripRepositoryImplProvider);
    state = AsyncValue.data(TripListState());
    await getTrips();

    return state.value!;
  }
}

final tripPageControllerProvider =
    AutoDisposeAsyncNotifierProvider<TripPageController, TripListState>(
        TripPageController.new);
