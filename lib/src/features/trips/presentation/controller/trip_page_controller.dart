import 'dart:async';

import 'package:alvys3/src/constants/api_routes.dart';
import 'package:alvys3/src/features/authentication/presentation/auth_provider_controller.dart';
import 'package:alvys3/src/features/trips/domain/providers/trip_provider.dart';
import 'package:alvys3/src/features/trips/data/repositories/trip_repository_impl.dart';
import 'package:alvys3/src/features/trips/domain/model/app_trip/app_trip.dart';
import 'package:alvys3/src/features/trips/domain/model/app_trip/trip_list_state.dart';
import 'package:alvys3/src/utils/platform_channel.dart';
import 'package:alvys3/src/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../utils/extensions.dart';

part 'trip_page_controller.g.dart';

@riverpod
class TripController extends _$TripController {
  late TripRepositoryImpl _tripRepositoryImpl;

  @override
  FutureOr<TripListState> build() async {
    _tripRepositoryImpl = ref.read(tripRepositoryImplProvider);
    state = AsyncValue.data(TripListState());
    await getTrips();

    if (state.value!.trips.isNotEmpty && state.value!.activeTrips.isNotEmpty) {
      var userState = ref.watch(authProvider);

      var authToken = Utils.base64String(
          "${userState.value!.driver!.userName!}:${userState.value!.driver!.appToken!}");
      if (await Permission.location.isGranted) {
        PlatformChannel.startLocationTracking(
            userState.value!.driver!.name!,
            state.value!.activeTrips.first.driver1Id!,
            state.value!.activeTrips.first.tripNumber!,
            state.value!.activeTrips.first.id!,
            authToken,
            ApiRoutes.locationTracking,
            state.value!.activeTrips.first.companyCode!);
      }
    } else {
      debugPrint("No trackable trips.");
    }

    return state.value!;
  }

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

  AppTrip? getTrip(String tripID) => state.value!.getTrip(tripID);

  Future<void> refreshTrips() async {
    final result = await _tripRepositoryImpl.getTrips();
    if (result.success) {
      var dataToGet = result.data!.data.toListNotNull();
      state = AsyncValue.data(state.value!.copyWith(trips: dataToGet));
    }
  }

  Future<void> refreshCurrentTrip(String tripId) async {
    final result = await _tripRepositoryImpl.getTripDetails(tripId);
    if (result.success) {
      var dataToGet = result.data!.data;
      int index = state.value!.trips
          .indexWhere((element) => element.id == dataToGet!.id!);
      var trips = List<AppTrip>.from(state.value!.trips);
      trips[index] = dataToGet!;
      state = AsyncValue.data(state.value!.copyWith(trips: trips));
    }
  }
}
