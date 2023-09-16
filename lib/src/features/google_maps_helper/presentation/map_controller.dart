import 'dart:async';

import 'package:alvys3/src/utils/map_styles.dart';
import 'package:alvys3/src/utils/theme_handler.dart';
import 'package:flutter/material.dart';

import '../data/google_maps_repository.dart';
import '../domain/map_state.dart';
import '../../trips/domain/app_trip/trip_list_state.dart';
import '../../trips/presentation/controller/trip_page_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapNotifier extends AutoDisposeFamilyAsyncNotifier<MapState, String> {
  Completer<GoogleMapController> controller = Completer();
  Completer<GoogleMapController> miniController = Completer();
  late GoogleMapsRepo repo;
  late AsyncValue<TripListState> trips;
  @override
  FutureOr<MapState> build(String arg) async {
    repo = ref.read(googleMapsRepo);
    trips = ref.watch(tripControllerProvider);
    state = AsyncData(MapState());
    setMapStyle();
    await getPolyLinesAndMarkers();
    return state.value!;
  }

  Future<void> getPolyLinesAndMarkers() async {
    var trip = trips.value!.tryGetTrip(arg);
    if (trip != null) {
      state = const AsyncLoading();
      var markers = trip.stopLocations
          .map((e) => Marker(markerId: MarkerId('${e.latitude}${e.longitude}_'), consumeTapEvents: true, position: e))
          .toSet();
      state = AsyncData(state.value!.copyWith(markers: markers));
      var polylines = await repo.getPolyLines(trip.stopLocations);
      state = AsyncData(MapState(markers: markers, polyLines: polylines.values.toSet()));
      GoogleMapController miniController = await this.miniController.future;
      miniController.animateCamera(
          CameraUpdate.newLatLngBounds(repo.boundsFromLatLngList(markers.map((e) => e.position).toList()), 72));
    }
  }

  void onMapCreated(GoogleMapController controller, [bool fullMap = false]) {
    if (fullMap) {
      // this.controller.complete(controller);
      controller.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(target: state.value!.markers.first.position, zoom: 15)));
    } else {
      miniController.complete(controller);
    }
    setMapStyle();
  }

  Future<void> onStopChanged(int index) async {
    var pos = state.value!.markers.elementAtOrNull(index);
    if (pos != null) {
      GoogleMapController controller = await this.controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: pos.position, zoom: 15)));
    }
  }

  Future setMapStyle() async {
    var mode = ref.read(themeHandlerProvider);
    final controller = await this.controller.future;
    final miniController = await this.miniController.future;
    if (mode == ThemeMode.system) {
      final theme = WidgetsBinding.instance.platformDispatcher.platformBrightness;

      if (theme == Brightness.dark) {
        controller.setMapStyle(darkMapStyle);
        miniController.setMapStyle(darkMapStyle);
      } else {
        controller.setMapStyle(liteMapStyle);

        miniController.setMapStyle(liteMapStyle);
      }
    } else {
      if (mode == ThemeMode.dark) {
        controller.setMapStyle(darkMapStyle);
        miniController.setMapStyle(darkMapStyle);
      } else {
        controller.setMapStyle(liteMapStyle);

        miniController.setMapStyle(liteMapStyle);
      }
    }
  }
}

final mapProvider = AutoDisposeAsyncNotifierProviderFamily<MapNotifier, MapState, String>(MapNotifier.new);
