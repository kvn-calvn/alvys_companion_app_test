import 'dart:async';

import '../../../../constants/api_routes.dart';
import '../../../authentication/presentation/auth_provider_controller.dart';
import '../../domain/model/app_trip/app_trip.dart';
import '../../domain/model/app_trip/trip_list_state.dart';
import '../../data/repositories/trip_repository.dart';
import '../../../../utils/magic_strings.dart';
import '../../../../utils/platform_channel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../utils/extensions.dart';

part 'trip_page_controller.g.dart';

@riverpod
class TripController extends _$TripController {
  late TripRepository tripRepo;

  @override
  FutureOr<TripListState> build() async {
    tripRepo = ref.read(tripRepoProvider);
    state = AsyncValue.data(TripListState());
    await getTrips();

    if (state.value!.trips.isNotEmpty && state.value!.activeTrips.isNotEmpty) {
      var userState = ref.watch(authProvider);
      var storage = const FlutterSecureStorage();
      var authToken = await storage.read(key: StorageKey.driverToken.name);
      if (await Permission.location.isGranted) {
        PlatformChannel.startLocationTracking(
          userState.value!.driver!.name!,
          state.value!.activeTrips.first.driver1Id!,
          state.value!.activeTrips.first.tripNumber!,
          state.value!.activeTrips.first.id!,
          authToken!,
          ApiRoutes.locationTracking,
          state.value!.activeTrips.first.companyCode!,
        );
      }
    } else {
      debugPrint("No trackable trips.");
    }

    return state.value!;
  }

  Future<void> getTrips() async {
    state = const AsyncValue.loading();
    final result = await tripRepo.getTrips<TripController>();
    state = AsyncValue.data(state.value!.copyWith(trips: result));
  }

  AppTrip? getTrip(String tripID) => state.value!.getTrip(tripID);

  Future<void> refreshTrips() async {
    final result = await tripRepo.getTrips<TripController>();
    var dataToGet = result.toListNotNull();
    state = AsyncValue.data(state.value!.copyWith(trips: dataToGet));
  }

  Future<void> refreshCurrentTrip(String tripId) async {
    var trip = state.value!.getTrip(tripId);
    final result = await tripRepo.getTripDetails<TripController>(tripId, trip.companyCode!);
    int index = state.value!.trips.indexWhere((element) => element.id == result.id!);
    var trips = List<AppTrip>.from(state.value!.trips);
    trips[index] = result;
    state = AsyncValue.data(state.value!.copyWith(trips: trips));
  }
}
