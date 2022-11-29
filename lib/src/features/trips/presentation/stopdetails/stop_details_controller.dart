import 'package:alvys3/src/features/trips/data/data_provider.dart';
import 'package:alvys3/src/features/trips/data/trip_repository_impl.dart';
import 'package:alvys3/src/features/trips/domain/stop_details/stop_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StopDetailsController extends StateNotifier<AsyncValue<StopDetails?>> {
  StopDetailsController(this._tripRepositoryImpl)
      : super(const AsyncValue.data(null));

  final TripRepositoryImpl _tripRepositoryImpl;

  void getStopDetails(String tripId, String stopId) async {
    state = const AsyncValue.loading();
    final result = await _tripRepositoryImpl.getStopDetails(tripId, stopId);
    if (result.success) {
      state = AsyncValue.data(result.data!);
    } else {
      state = AsyncValue.error(result.error!, StackTrace.current);
    }
  }
}

final stopDetailsControllerProvider = StateNotifierProvider.autoDispose<
    StopDetailsController, AsyncValue<StopDetails?>>((ref) {
  return StopDetailsController(ref.watch(tripRepositoryImplProvider));
});
