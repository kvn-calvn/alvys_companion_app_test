import 'package:alvys3/src/features/trips/data/data_provider.dart';
import 'package:alvys3/src/features/trips/data/trip_repository_impl.dart';
import 'package:alvys3/src/features/trips/domain/trip_details/trip_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TripDetailsController extends StateNotifier<AsyncValue<TripDetails?>> {
  TripDetailsController(this._tripRepositoryImpl)
      : super(const AsyncValue.data(null));

  final TripRepositoryImpl _tripRepositoryImpl;

  void getTripDetails(String tripId) async {
    state = const AsyncValue.loading();
    final result = await _tripRepositoryImpl.getTripDetails(tripId);
    if (result.success) {
      state = AsyncValue.data(result.data!);
    } else {
      state = AsyncValue.error(result.error!);
    }
  }
}

final tripDetailsControllerProvider = StateNotifierProvider.autoDispose<
    TripDetailsController, AsyncValue<TripDetails?>>((ref) {
  return TripDetailsController(ref.watch(tripRepositoryImplProvider));
});
