import 'dart:async';

import 'package:alvys3/src/features/trips/data/data_provider.dart';
import 'package:alvys3/src/features/trips/data/trip_repository_impl.dart';
import 'package:alvys3/src/features/trips/domain/trips/trips.dart';
import 'package:alvys3/src/network/api_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getTripsProvider = FutureProvider<ApiResponse<Trips?>>((ref) async {
  final trips = await ref.read(tripRepositoryImplProvider).getTrips();
  return trips;
});

class TripPageController extends AutoDisposeAsyncNotifier<Trips?> {
  late TripRepositoryImpl _tripRepositoryImpl;

  Future<void> getTrips() async {
    state = const AsyncValue.loading();
    final result = await _tripRepositoryImpl.getTrips();
    if (result.success) {
      state = AsyncValue.data(result.data!);
    } else {
      state = AsyncValue.error(result.error!, StackTrace.current);
    }
  }

  @override
  FutureOr<Trips?> build() async {
    _tripRepositoryImpl = ref.read(tripRepositoryImplProvider);
    await getTrips();
    return null;
  }
}

final tripPageControllerProvider =
    AutoDisposeAsyncNotifierProvider<TripPageController, Trips?>(
        TripPageController.new);
