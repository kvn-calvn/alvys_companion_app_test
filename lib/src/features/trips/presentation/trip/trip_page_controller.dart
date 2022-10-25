import 'package:alvys3/src/features/trips/data/data_provider.dart';
import 'package:alvys3/src/features/trips/data/trip_repository_impl.dart';
import 'package:alvys3/src/features/trips/domain/trips/trips.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TripPageController extends StateNotifier<AsyncValue<Trips?>> {
  TripPageController(this._tripRepositoryImpl)
      : super(const AsyncValue.data(null));

  final TripRepositoryImpl _tripRepositoryImpl;

  void getTrips() async {
    state = const AsyncValue.loading();
    final result = await _tripRepositoryImpl.getTrips();
    if (result.success) {
      state = AsyncValue.data(result.data!);
    } else {
      state = AsyncValue.error(result.error!);
    }
  }
}

final tripPageControllerProvider =
    StateNotifierProvider.autoDispose<TripPageController, AsyncValue<Trips?>>(
        (ref) {
  return TripPageController(ref.watch(tripRepositoryImplProvider));
});
