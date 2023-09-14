import 'dart:async';

import '../../domain/app_trip/echeck.dart';

import '../../domain/app_trip/stop.dart';
import '../../domain/update_stop_time_record/update_stop_time_record.dart';
import '../../../../utils/exceptions.dart';
import '../../../../utils/helpers.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../constants/api_routes.dart';
import '../../../authentication/presentation/auth_provider_controller.dart';
import '../../domain/app_trip/app_trip.dart';
import '../../domain/app_trip/trip_list_state.dart';
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
class TripController extends _$TripController implements IAppErrorHandler {
  late TripRepository tripRepo;

  @override
  FutureOr<TripListState> build() async {
    tripRepo = ref.read(tripRepoProvider);
    state = AsyncValue.data(TripListState());
    await getTrips();

    if (state.value!.activeTrips.isNotEmpty) {
      var trackingTrip = state.value!.activeTrips.firstWhereOrNull((e) => e.status == TripStatus.inTransit) ??
          state.value!.activeTrips.first;
      var userState = ref.watch(authProvider);
      var storage = const FlutterSecureStorage();
      var authToken = await storage.read(key: StorageKey.driverToken.name);
      if (await Permission.location.isGranted) {
        PlatformChannel.startLocationTracking(
          userState.value!.driver!.name!,
          trackingTrip.driver1Id!,
          trackingTrip.tripNumber!,
          trackingTrip.id!,
          authToken!,
          ApiRoutes.locationTracking,
          trackingTrip.companyCode!,
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

  void updateTrip(AppTrip trip) {
    if (!state.isLoading && state.value.isNotNull) {
      int index = state.value!.trips.indexWhere((element) => element.id == trip.id!);
      var trips = List<AppTrip>.from(state.value!.trips);
      if (index > -1) {
        trips[index] = trip;
        state = AsyncValue.data(state.value!.copyWith(trips: trips));
      } else {
        var user = ref.read(authProvider.notifier).driver;
        if (trip.drivers!.removeNulls.contains(user?.phone)) {
          trips.add(trip);
          state = AsyncValue.data(state.value!.copyWith(trips: trips));
        }
      }
    }
  }

  Future<void> refreshCurrentTrip(String tripId) async {
    var trip = state.value!.getTrip(tripId);
    final result = await tripRepo.getTripDetails<TripController>(tripId, trip.companyCode!);
    int index = state.value!.trips.indexWhere((element) => element.id == result.id!);
    var trips = List<AppTrip>.from(state.value!.trips);
    trips[index] = result;
    state = AsyncValue.data(state.value!.copyWith(trips: trips));
  }

  Future<void> checkIn(String tripId, String stopId) async {
    state = AsyncValue.data(state.value!.copyWith(loadingStopId: stopId, checkIn: true));
    var trip = state.value!.tryGetTrip(tripId);
    if (trip == null) return;
    var stop = trip.stops!.firstWhereOrNull((element) => element.stopId == stopId);
    if (stop == null) return;
    var location = await Helpers.getUserPosition(() {
      state = AsyncValue.data(state.value!.copyWith(loadingStopId: null));
    });
    var distance = Geolocator.distanceBetween(
        location.latitude, location.longitude, double.parse(stop.latitude!), double.parse(stop.longitude!));
    if (distance > 10) {
      throw AlvysException('''You are too far from the stop location to check in.
      Move closer and try again.''', 'Too Far', () {
        state = AsyncValue.data(state.value!.copyWith(loadingStopId: null));
      });
    }
    var dto = UpdateStopTimeRecord(latitude: location.latitude, longitude: location.longitude, timeIn: DateTime.now());
    var newStop = await tripRepo.updateStopTimeRecord(trip.companyCode!, tripId, stopId, dto);
    updateStop(tripId, newStop);
    state = AsyncValue.data(state.value!.copyWith(loadingStopId: null, checkIn: true));
  }

  Future<void> checkOut(String tripId, String stopId) async {
    state = AsyncValue.data(state.value!.copyWith(loadingStopId: stopId, checkIn: false));
    var trip = state.value!.tryGetTrip(tripId);
    if (trip == null) return;
    var location = await Helpers.getUserPosition(() {
      state = AsyncValue.data(state.value!.copyWith(loadingStopId: null));
    });
    var dto = UpdateStopTimeRecord(latitude: location.latitude, longitude: location.longitude, timeOut: DateTime.now());
    var stop = await tripRepo.updateStopTimeRecord(trip.companyCode!, tripId, stopId, dto);
    updateStop(tripId, stop);
    state = AsyncValue.data(state.value!.copyWith(loadingStopId: null, checkIn: false));
  }

  void updateStop(String tripId, Stop stop) async {
    var trip = state.value!.getTrip(tripId);
    int index = state.value!.trips.indexWhere((element) => element.id == trip.id!);
    var trips = List<AppTrip>.from(state.value!.trips);
    int stopIndex = trip.stops!.indexWhere((element) => element.stopId == stop.stopId!);
    var stops = List<Stop>.from(trip.stops!);
    stops[stopIndex] = stop;
    trips[index] = trip.copyWith(stops: stops);
    state = AsyncValue.data(state.value!.copyWith(trips: trips));
  }

  void addEcheck(String tripId, ECheck echeck) {
    var trip = getTrip(tripId);
    if (trip == null) return;
    trip = trip.copyWith(eChecks: [...trip.eChecks ?? [], echeck]);
    updateTrip(trip);
  }

  void updateEcheck(String tripId, ECheck echeck) {
    var trip = getTrip(tripId);
    if (trip == null) return;
    var currentECheckIndex = trip.eChecks?.indexWhere((element) => element.eCheckId == echeck.eCheckId);
    if (currentECheckIndex == null || currentECheckIndex < 0) return;
    trip.eChecks![currentECheckIndex] = echeck;
    updateTrip(trip);
  }

  @override
  FutureOr<void> onError() {
    state = AsyncData(state.value!.copyWith(loadingStopId: null));
  }
}
