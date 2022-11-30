import 'dart:async';
import 'dart:ffi';

import 'package:alvys3/src/features/trips/data/data_provider.dart';
//import 'package:alvys3/src/features/trips/data/trip_repository_impl.dart';
import 'package:alvys3/src/features/trips/domain/trip_details/trip_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TripDetailsController extends AutoDisposeAsyncNotifier<TripDetails?> {
  @override
  FutureOr<TripDetails?> build() {
    throw UnimplementedError();
  }

  //final TripRepositoryImpl _tripRepositoryImpl;

  Future<void> getTripDetails(String tripId) async {
    final tripRepo = ref.read(tripRepositoryImplProvider);

    state = const AsyncLoading();
    final result = await tripRepo.getTripDetails(tripId);
    if (result.success) {
      state = AsyncValue.data(result.data!);
    } else {
      state = AsyncValue.error(result.error!, StackTrace.current);
    }
  }

/*
  void getTripDetails1(String tripId) async {
    state = const AsyncValue.loading();
    final result = await _tripRepositoryImpl.getTripDetails(tripId);
    if (result.success) {
      state = AsyncValue.data(result.data!);
    } else {
      state = AsyncValue.error(result.error!, StackTrace.current);
    }
  }*/
}

final tripDetailsControllerProvider =
    AsyncNotifierProvider.autoDispose<TripDetailsController, TripDetails?>(
        TripDetailsController.new);
/*
final tripDetailsControllerProvider = StateNotifierProvider.autoDispose<
    TripDetailsController, AsyncValue<TripDetails?>>((ref) {
  return TripDetailsController(ref.watch(tripRepositoryImplProvider));
});*/
