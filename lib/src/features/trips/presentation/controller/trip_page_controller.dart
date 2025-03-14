import 'dart:async';

import '../../../../network/posthog/domain/posthog_objects.dart';
import '../../../trailers/domain/trailer_request/trailer_request.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common_widgets/snack_bar.dart';
import '../../../../constants/api_routes.dart';
import '../../../../network/firebase_remote_config_service.dart';
import '../../../../network/http_client.dart';
import '../../../../network/posthog/posthog_provider.dart';
import '../../../../utils/dummy_data.dart';
import '../../../../utils/exceptions.dart';
import '../../../../utils/helpers.dart';
import '../../../../utils/magic_strings.dart';
import '../../../../utils/permission_helper.dart';
import '../../../../utils/platform_channel.dart';
import '../../../../utils/provider_args_saver.dart';
import '../../../../utils/tablet_utils.dart';
import '../../../authentication/presentation/auth_provider_controller.dart';
import '../../../echeck/presentation/pages/generate_echeck.dart';
import '../../../tutorial/tutorial_controller.dart';
import '../../data/repositories/trip_repository.dart';
import '../../domain/app_trip/app_trip.dart';
import '../../domain/app_trip/echeck.dart';
import '../../domain/app_trip/stop.dart';
import '../../domain/app_trip/trip_list_state.dart';
import '../../domain/update_stop_time_record/update_stop_time_record.dart';

part 'trip_page_controller.g.dart';

@riverpod
class TripController extends _$TripController implements IErrorHandler {
  late TripRepository tripRepo;
  late AuthProviderNotifier auth;
  late TutorialController tutorial;
  late SharedPreferences pref;
  String? tripId;
  @override
  FutureOr<TripListState> build() async {
    tripRepo = ref.read(tripRepoProvider);
    auth = ref.read(authProvider.notifier);
    tutorial = ref.read(tutorialProvider);
    pref = ref.read(sharedPreferencesProvider)!;

    if (!tutorial.firstInstall.currentState) {
      state = AsyncValue.data(TripListState());
      await getTrips();
    } else {
      state = AsyncValue.data(TripListState(trips: [testTrip]));
    }

    // If the system can show an authorization request dialog
    if (await AppTrackingTransparency.trackingAuthorizationStatus == TrackingStatus.notDetermined) {
      await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
    await auth.refreshDriverUser();

    return state.value!;
  }

  Future<void> showTripListPreview(BuildContext context, int startIndex, int endIndex, [void Function()? onEnd]) async {
    if (state.isLoading) return;
    state = AsyncValue.data(TripListState(trips: [testTrip]));
    tutorial.showTutorialSection(context, startIndex, endIndex, () async {
      refreshTrips(true);
      onEnd?.call();
    });
  }

  Future<void> showTripDetailsTutorialPreview(
      BuildContext context, int startIndex, int endIndex, String currentTripId) async {
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
    if (tutorial.firstInstall.currentState) return;
    var status = newStatus ?? pref.getString(SharedPreferencesKey.driverStatus.name);
    if (state.value!.activeTrips.isNotEmpty && (status.equalsIgnoreCase(DriverStatus.online) || status == null)) {
      var trackingTrip = state.value!.trackingTrip;
      if (await Permission.location.isGranted) {
        startTracking(trackingTrip);
      }
    } else {
      PlatformChannel.stopLocationTracking();
    }
  }

  Future<void> updateDriverStatus(String? status) async {
    if (status != null) {
      ref.read(postHogProvider).postHogTrackEvent("user_status_${status.toLowerCase()}", null);
      if (status.equalsIgnoreCase(DriverStatus.online)) {
        startLocationTracking(status);
      } else {
        if (await Permission.location.status.isGranted) {
          PlatformChannel.stopLocationTracking();
        }
      }
      await auth.updateDriverStatus(status);
    }
  }

  void updateTrailerNumber(SetTrailerDto dto) {
    var trip = getTrip(dto.tripId);
    if (trip == null && dto.isValid) return;
    var updatedTrip = trip!.copyWith(trailerNum: dto.trailerNumber, trailerId: dto.trailerId);
    updateTrip(updatedTrip);
  }

  Future<void> getTrips() async {
    state = const AsyncValue.loading();
    final result = await tripRepo.getTrips<TripController>();
    if (!ref.exists(tripControllerProvider)) return;
    state = AsyncValue.data(state.value!.copyWith(trips: result));
    await startLocationTracking();
  }

  Future<void> endTutorial() async {
    await pref.setBool(SharedPreferencesKey.firstInstall.name, false);
    await getTrips();
  }

  Future<void> startTracking(AppTrip trip) async {
    if (!trip.isTrackable) return;
    var authToken = pref.getString(SharedPreferencesKey.driverToken.name);
    var userState = ref.read(authProvider);
    var res = await PermissionHelper.getPermission(Permission.location);
    if (res) {
      PlatformChannel.startLocationTracking(
        userState.value!.driver!.name ?? "",
        trip.driver1Id!,
        trip.tripNumber!,
        trip.id!,
        authToken!,
        ApiRoutes.locationTracking,
        trip.companyCode!,
      );
    }
  }

  AppTrip? getTrip(String tripID) => state.value!.tryGetTrip(tripID);
  Stop? getStop(String tripID, String? stopId) => state.value!.tryGetStop(tripID, stopId);

  Future<void> refreshTrips([bool addLoading = false]) async {
    if (addLoading) state = const AsyncLoading();
    final result = await tripRepo.getTrips<TripController>();
    await auth.refreshDriverUser();
    var dataToGet = result.toList();
    state = AsyncValue.data(state.value!.copyWith(trips: dataToGet, loadingStopId: null));
  }

  void updateTrip(AppTrip trip) {
    if (!state.isLoading && state.value.isNotNull) {
      int index = state.value!.trips.indexWhere((element) => element.id == trip.id!);
      var trips = List<AppTrip>.from(state.value!.trips);
      var user = auth.driver;
      if (index > -1) {
        if (trip.drivers.removeNulls.contains(user?.phone)) {
          trips[index] = trip;
          state = AsyncValue.data(state.value!.copyWith(trips: trips));
        } else {
          // remove trip if driver has trip in list but is removed from the trip
          state = AsyncValue.data(state.value!.copyWith(trips: trips.where((x) => x.id != trip.id!).toList()));
        }
      } else {
        if (trip.drivers.removeNulls.contains(user?.phone)) {
          state = AsyncValue.data(state.value!.copyWith(trips: [...trips, trip]));
          startLocationTracking();
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
    await auth.refreshDriverUser();
    state = AsyncValue.data(state.value!.copyWith(trips: trips, loadingStopId: null));
  }

  Future<void> checkIn(String tripId, String stopId) async {
    var showDistance = ref.watch(firebaseRemoteConfigServiceProvider).showTooFarDistance();
    final postHogService = ref.read(postHogProvider);
    state = AsyncValue.data(state.value!.copyWith(loadingStopId: stopId, checkIn: true));
    var trip = state.value!.tryGetTrip(tripId);
    if (trip == null) return;
    var stop = trip.stops.firstWhereOrNull((element) => element.stopId == stopId);
    if (stop == null) return;
    var location = await Helpers.getUserPosition(() {
      state = AsyncValue.data(state.value!.copyWith(loadingStopId: null));
    });
    stop.validateCoordinates(() {
      state = AsyncValue.data(state.value!.copyWith(loadingStopId: null));
    });
    var distance = Geolocator.distanceBetween(
            location.latitude, location.longitude, double.parse(stop.latitude!), double.parse(stop.longitude!)) /
        1609.34;
    var event = PosthogTimeRecordLog(
        tenant: trip.companyCode!,
        tripNumber: trip.tripNumber!,
        tripId: tripId,
        stopId: stopId,
        stopAddress: stop.tripCardAddress,
        loadNumber: trip.loadNumber!,
        success: true,
        distance: '$distance miles',
        location: '${location.latitude}, ${location.longitude}');
    if (distance > 10) {
      postHogService
          .postHogTrackEvent(PosthogTag.userCheckedIn.toSnakeCase, {...event.copyWith(success: false).toJson()});
      ref.read(httpClientProvider).telemetryClient.trackEvent(name: "distance_too_far", additionalProperties: {
        "location": '${location.latitude}, ${location.longitude}',
        "distance": '$distance miles'
      });
      await FirebaseAnalytics.instance.logEvent(
          name: "distance_too_far",
          parameters: {"location": '${location.latitude}, ${location.longitude}', "distance": '$distance miles'});
      String distanceMessage =
          '''You are ${NumberFormat.decimalPattern().format(double.parse((distance).toStringAsFixed(2)))}mi away from the stop location to check in.
      Move closer and try again.''';

      String noDistanceMessage = ''' You are too far from the stop location to check in.
      Move closer and try again.''';
      throw AlvysException(showDistance ? distanceMessage : noDistanceMessage, 'Too Far', () {
        state = AsyncValue.data(state.value!.copyWith(loadingStopId: null));
      });
    }
    var dto = UpdateStopTimeRecord(latitude: location.latitude, longitude: location.longitude, timeIn: DateTime.now());
    var newStop = await tripRepo.updateStopTimeRecord<TripController>(trip.companyCode!, tripId, stopId, dto);
    updateStop(tripId, newStop);
    startLocationTracking();
    state = AsyncValue.data(state.value!.copyWith(loadingStopId: null, checkIn: true));
    postHogService.postHogTrackEvent(PosthogTag.userCheckedIn.toSnakeCase, {...event.copyWith(success: true).toJson()});
    ref.read(httpClientProvider).telemetryClient.trackEvent(name: "checked_in", additionalProperties: {
      "location": '${location.latitude}, ${location.longitude}',
      "stop": stop.companyName ?? "-"
    });
    await FirebaseAnalytics.instance.logEvent(
        name: "checked_in",
        parameters: {"location": '${location.latitude}, ${location.longitude}', "stop": '${stop.companyName}'});
  }

  Future<void> checkOut(String tripId, String stopId) async {
    state = AsyncValue.data(state.value!.copyWith(loadingStopId: stopId, checkIn: false));
    var trip = state.value!.tryGetTrip(tripId);
    if (trip == null) return;
    var location = await Helpers.getUserPosition(() {
      state = AsyncValue.data(state.value!.copyWith(loadingStopId: null));
    });
    var oldStop = state.value!.tryGetStop(tripId, stopId);
    ValidationContract.requireNotNull(
        oldStop?.arrived, 'Error', "There was an issue checking out, refresh and try again",
        actions: [
          ErrorDataAction(
              title: "",
              op: () {
                onError(Exception());
              })
        ]);

    var dto = UpdateStopTimeRecord(
        latitude: location.latitude,
        longitude: location.longitude,
        timeIn: oldStop!.arrived!.localDate,
        timeOut: DateTime.now().toUtc());
    var stop = await tripRepo.updateStopTimeRecord<TripController>(trip.companyCode!, tripId, stopId, dto);
    updateStop(tripId, stop);
    startLocationTracking();
    state = AsyncValue.data(state.value!.copyWith(loadingStopId: null, checkIn: false));
    var distance = Geolocator.distanceBetween(
            location.latitude, location.longitude, double.parse(stop.latitude!), double.parse(stop.longitude!)) /
        1609.34;
    var event = PosthogTimeRecordLog(
        tenant: trip.companyCode!,
        tripNumber: trip.tripNumber!,
        tripId: tripId,
        stopId: stopId,
        stopAddress: stop.tripCardAddress,
        loadNumber: trip.loadNumber!,
        success: null,
        distance: '$distance miles',
        location: '${location.latitude}, ${location.longitude}');
    //2024-10-22T14:00:00-04:00
    ref.read(postHogProvider).postHogTrackEvent(PosthogTag.userCheckedOut.toSnakeCase, {...event.toJson()});
    ref.read(httpClientProvider).telemetryClient.trackEvent(name: "checked_out", additionalProperties: {
      "location": '${location.latitude}, ${location.longitude}',
      "stop": stop.companyName ?? "-"
    });
    await FirebaseAnalytics.instance.logEvent(
        name: "checked_out",
        parameters: {"location": '${location.latitude}, ${location.longitude}', "stop": '${stop.companyName}'});
  }

  void updateStop(String tripId, Stop stop) async {
    var trip = state.value!.getTrip(tripId);
    int index = state.value!.trips.indexWhere((element) => element.id == trip.id!);
    var trips = List<AppTrip>.from(state.value!.trips);
    int stopIndex = trip.stops.indexWhere((element) => element.stopId == stop.stopId!);
    var stops = List<Stop>.from(trip.stops);
    stops[stopIndex] = stop;
    trips[index] = trip.copyWith(stops: stops);
    state = AsyncValue.data(state.value!.copyWith(trips: trips));
  }

  void addEcheck(String tripId, ECheck echeck) {
    var trip = getTrip(tripId);
    if (trip == null) return;
    var existingCheck =
        trip.eChecks.firstWhereOrNull((element) => element.expressCheckNumber == echeck.expressCheckNumber);
    if (existingCheck != null) {
      updateEcheck(tripId, echeck);
    } else {
      trip = trip.copyWith(eChecks: [...trip.eChecks, echeck]);
      updateTrip(trip);
    }
  }

  void updateEcheck(String tripId, ECheck echeck) {
    var trip = getTrip(tripId);
    if (trip == null) return;
    var currentECheckIndex = trip.eChecks.indexWhere((element) => element.eCheckId == echeck.eCheckId);
    if (currentECheckIndex < 0) return;
    var updatedECheckList = List<ECheck>.from(trip.eChecks);
    updatedECheckList[currentECheckIndex] = echeck;
    trip = trip.copyWith(eChecks: updatedECheckList);
    updateTrip(trip);
  }

  bool shouldShowEcheckButton(String? tripId) {
    if (tripId == null) return false;
    var currentTrip = state.value!.tryGetTrip(tripId);
    if (currentTrip == null) return false;
    return auth.state.value!.shouldShowEcheckButton(currentTrip.companyCode!) &&
        !currentTrip.id.inIgnoreCase(state.value!.processingTrips.map((e) => e.id!));
  }

  Future<void> generateEcheckDialog(BuildContext context, String tripId, String stopId) async {
    var res = await showGenerateEcheckDialog(context, tripId, stopId);
    if (res != null) {
      SnackBar snackBar = SnackBarWrapper.getSnackBar('E-Check $res generated successfully');
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        TabletUtils.instance.detailsController.animateTo(1);
      });
    }
  }

  @override
  FutureOr<void> onError(Exception ex) {
    state = AsyncData(state.value!.copyWith(
      trips: state.value!.trips.where((element) => element.id != testTrip.id).toList(),
      loadingStopId: null,
    ));
  }

  @override
  FutureOr<void> refreshPage(String page) async {
    await getTrips();
  }

  String tabName(int index) {
    return switch (index) { 0 => "Trip details", 1 => "Echecks", _ => 'Trip documents' };
  }
}
