import 'dart:async';

import 'package:alvys3/src/network/http_client.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../../../../utils/permission_helper.dart';

import '../../../tutorial/tutorial_controller.dart';
import '../../../../utils/dummy_data.dart';
import 'package:go_router/go_router.dart';
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
  late AuthProviderNotifier auth;
  late TutorialController tutorial;
  String? tripId;
  var storage = const FlutterSecureStorage();
  @override
  FutureOr<TripListState> build() async {
    tripRepo = ref.read(tripRepoProvider);
    auth = ref.read(authProvider.notifier);
    tutorial = ref.read(tutorialProvider);
    if (!tutorial.firstInstall.currentState) {
      state = AsyncValue.data(TripListState());
      await getTrips();
    } else {
      state = AsyncValue.data(TripListState(trips: [testTrip]));
    }

    return state.value!;
  }

  Future<void> showTripListPreview(
      BuildContext context, int startIndex, int endIndex,
      [void Function()? onEnd]) async {
    if (state.isLoading) return;
    state = AsyncValue.data(TripListState(trips: [testTrip]));
    tutorial.showTutorialSection(context, startIndex, endIndex, () async {
      refreshTrips(true);
      onEnd?.call();
    });
  }

  Future<void> showTripDetailsTutorialPreview(BuildContext context,
      int startIndex, int endIndex, String currentTripId) async {
    if (state.isLoading) return;
    tripId = currentTripId;
    await showTripListPreview(context, startIndex, endIndex, () {
      context.goNamed(
        RouteName.tripDetails.name,
        pathParameters: {ParamType.tripId.name: tripId!},
        queryParameters: {ParamType.tabIndex.name: (startIndex - 1).toString()},
      );
    });
    if (context.mounted) {
      context.goNamed(
        RouteName.tripDetails.name,
        pathParameters: {ParamType.tripId.name: testTrip.id!},
        queryParameters: {ParamType.tabIndex.name: (startIndex - 1).toString()},
      );
    }
  }

  void handleAfterTutorial(BuildContext context) {
    context.goNamed(RouteName.trips.name);
    refreshTrips(true);
  }

  Future<void> startLocationTracking([String? newStatus]) async {
    var status =
        newStatus ?? await storage.read(key: StorageKey.driverStatus.name);
    if (state.value!.activeTrips.isNotEmpty &&
        (status.equalsIgnoreCase(DriverStatus.online) || status == null)) {
      var trackingTrip = state.value!.activeTrips
              .firstWhereOrNull((e) => e.status == TripStatus.inTransit) ??
          state.value!.activeTrips.first;
      if (await Permission.location.isGranted) {
        startTracking(trackingTrip);
      }
    } else {
      PlatformChannel.stopLocationTracking();
      debugPrint("No trackable trips.");
    }
  }

  Future<void> updateDriverStatus(String? status) async {
    if (status != null) {
      if (status.equalsIgnoreCase(DriverStatus.online)) {
        startLocationTracking(status);
      } else {
        PlatformChannel.stopLocationTracking();
      }
      await auth.updateDriverStatus(status);
    }
  }

  Future<void> getTrips() async {
    state = const AsyncValue.loading();
    final result = await tripRepo.getTrips<TripController>();
    state = AsyncValue.data(state.value!.copyWith(trips: result));
    await startLocationTracking();
  }

  Future<void> endTutorial() async {
    await storage.write(key: StorageKey.firstInstall.name, value: 'false');
    await getTrips();
  }

  Future<void> startTracking(AppTrip trip) async {
    var authToken = await storage.read(key: StorageKey.driverToken.name);
    var userState = ref.read(authProvider);
    var res = await PermissionHelper.getPermission(Permission.location);
    if (res) {
      PlatformChannel.startLocationTracking(
        userState.value!.driver!.name!,
        trip.driver1Id!,
        trip.tripNumber!,
        trip.id!,
        authToken!,
        ApiRoutes.locationTracking,
        trip.companyCode!,
      );
    }
  }

  AppTrip? getTrip(String tripID) => state.value!.getTrip(tripID);

  Future<void> refreshTrips([bool addLoading = false]) async {
    if (addLoading) state = const AsyncLoading();
    final result = await tripRepo.getTrips<TripController>();
    await auth.refreshDriverUser();
    var dataToGet = result.toListNotNull();
    state = AsyncValue.data(state.value!.copyWith(trips: dataToGet));
  }

  void updateTrip(AppTrip trip) {
    if (!state.isLoading && state.value.isNotNull) {
      int index =
          state.value!.trips.indexWhere((element) => element.id == trip.id!);
      var trips = List<AppTrip>.from(state.value!.trips);
      if (index > -1) {
        trips[index] = trip;
        state = AsyncValue.data(state.value!.copyWith(trips: trips));
      } else {
        var user = auth.driver;
        if (trip.drivers!.removeNulls.contains(user?.phone)) {
          trips.add(trip);
          state = AsyncValue.data(state.value!.copyWith(trips: trips));
        }
      }
    }
  }

  Future<void> refreshCurrentTrip(String tripId) async {
    var trip = state.value!.getTrip(tripId);
    final result = await tripRepo.getTripDetails<TripController>(
        tripId, trip.companyCode!);
    int index =
        state.value!.trips.indexWhere((element) => element.id == result.id!);
    var trips = List<AppTrip>.from(state.value!.trips);
    trips[index] = result;
    state = AsyncValue.data(state.value!.copyWith(trips: trips));
  }

  Future<void> checkIn(String tripId, String stopId) async {
    state = AsyncValue.data(
        state.value!.copyWith(loadingStopId: stopId, checkIn: true));
    var trip = state.value!.tryGetTrip(tripId);
    if (trip == null) return;
    var stop =
        trip.stops!.firstWhereOrNull((element) => element.stopId == stopId);
    if (stop == null) return;
    var location = await Helpers.getUserPosition(() {
      state = AsyncValue.data(state.value!.copyWith(loadingStopId: null));
    });
    var distance = Geolocator.distanceBetween(
        location.latitude,
        location.longitude,
        double.parse(stop.latitude!),
        double.parse(stop.longitude!));
    if (distance > 10) {
      ref
          .read(httpClientProvider)
          .telemetryClient
          .trackEvent(name: "distance_too_far", additionalProperties: {
        "location": '${location.latitude}, ${location.longitude}',
        "distance": '$distance meters'
      });
      await FirebaseAnalytics.instance
          .logEvent(name: "distance_too_far", parameters: {
        "location": '${location.latitude}, ${location.longitude}',
        "distance": '$distance meters'
      });
      throw AlvysException(
          '''You are too far from the stop location to check in.
      Move closer and try again.''', 'Too Far', () {
        state = AsyncValue.data(state.value!.copyWith(loadingStopId: null));
      });
    }
    var dto = UpdateStopTimeRecord(
        latitude: location.latitude,
        longitude: location.longitude,
        timeIn: DateTime.now());
    var newStop = await tripRepo.updateStopTimeRecord(
        trip.companyCode!, tripId, stopId, dto);
    updateStop(tripId, newStop);
    startTracking(trip);
    state = AsyncValue.data(
        state.value!.copyWith(loadingStopId: null, checkIn: true));
    ref
        .read(httpClientProvider)
        .telemetryClient
        .trackEvent(name: "checked_in", additionalProperties: {
      "location": '${location.latitude}, ${location.longitude}',
      "stop": stop.companyName ?? "-"
    });
    await FirebaseAnalytics.instance.logEvent(name: "checked_in", parameters: {
      "location": '${location.latitude}, ${location.longitude}',
      "stop": stop.companyName
    });
  }

  Future<void> checkOut(String tripId, String stopId) async {
    state = AsyncValue.data(
        state.value!.copyWith(loadingStopId: stopId, checkIn: false));
    var trip = state.value!.tryGetTrip(tripId);
    if (trip == null) return;
    var location = await Helpers.getUserPosition(() {
      state = AsyncValue.data(state.value!.copyWith(loadingStopId: null));
    });
    var dto = UpdateStopTimeRecord(
        latitude: location.latitude,
        longitude: location.longitude,
        timeOut: DateTime.now());
    var stop = await tripRepo.updateStopTimeRecord(
        trip.companyCode!, tripId, stopId, dto);
    updateStop(tripId, stop);
    startTracking(trip);
    state = AsyncValue.data(
        state.value!.copyWith(loadingStopId: null, checkIn: false));
    ref
        .read(httpClientProvider)
        .telemetryClient
        .trackEvent(name: "checked_out", additionalProperties: {
      "location": '${location.latitude}, ${location.longitude}',
      "stop": stop.companyName ?? "-"
    });
    await FirebaseAnalytics.instance.logEvent(name: "checked_out", parameters: {
      "location": '${location.latitude}, ${location.longitude}',
      "stop": stop.companyName
    });
  }

  void updateStop(String tripId, Stop stop) async {
    var trip = state.value!.getTrip(tripId);
    int index =
        state.value!.trips.indexWhere((element) => element.id == trip.id!);
    var trips = List<AppTrip>.from(state.value!.trips);
    int stopIndex =
        trip.stops!.indexWhere((element) => element.stopId == stop.stopId!);
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
    var currentECheckIndex = trip.eChecks
        ?.indexWhere((element) => element.eCheckId == echeck.eCheckId);
    if (currentECheckIndex == null || currentECheckIndex < 0) return;
    trip.eChecks![currentECheckIndex] = echeck;
    updateTrip(trip);
  }

  @override
  FutureOr<void> onError() {
    state = AsyncData(state.value!.copyWith(loadingStopId: null));
  }
}
