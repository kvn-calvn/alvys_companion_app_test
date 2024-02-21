import 'dart:async';

import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/services.dart';

import '../../../utils/map_styles.dart';
import '../../../utils/theme_handler.dart';
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
    state = const AsyncLoading();
    await getPolyLinesAndMarkers();
    return state.value!;
  }

  Future<void> getPolyLinesAndMarkers() async {
    var trip = trips.value!.tryGetTrip(arg);
    if (trip != null) {
      state = const AsyncLoading();
      var deliveryBytes = await repo.getMapMarkerBytesFromAsset('assets/delivery-1.png');
      var pickupBytes = await repo.getMapMarkerBytesFromAsset('assets/pickup-1.png');
      var delivery = deliveryBytes == null
              ? BitmapDescriptor.defaultMarkerWithHue(199)
              : BitmapDescriptor.fromBytes(deliveryBytes),
          pickup =
              pickupBytes == null ? BitmapDescriptor.defaultMarkerWithHue(0) : BitmapDescriptor.fromBytes(pickupBytes);

      var markers = trip.stopLocations
          .map((e) => Marker(
              markerId: MarkerId('${e.value.latitude}${e.value.longitude}_'),
              icon: e.key.equalsIgnoreCase('pickup') ? pickup : delivery,
              consumeTapEvents: true,
              position: e.value))
          .toSet();
      if (markers.isNullOrEmpty) {
        state = AsyncData(MapState());
        return;
      }
      state = AsyncData(MapState(markers: markers));
      GoogleMapController miniController = await this.miniController.future;
      state = const AsyncLoading();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        try {
          try {
            miniController.animateCamera(
                CameraUpdate.newLatLngBounds(repo.boundsFromLatLngList(markers.map((e) => e.position).toList()), 72));
          } catch (e) {
            miniController
                .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: markers.first.position)));
          }
          // ignore: empty_catches
        } on PlatformException {}
      });
      var polylines = await repo.getPolyLines(trip.stopLocations.map((e) => e.value).toList());
      state = AsyncData(MapState(markers: markers, polyLines: polylines.values.toSet()));
    } else {
      state = AsyncData(MapState());
    }
  }

  void onMapCreated(GoogleMapController controller, [bool fullMap = false]) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (fullMap) {
        this.controller = Completer();
        this.controller.complete(controller);
        setMapStyle();
        controller.animateCamera(
            CameraUpdate.newCameraPosition(CameraPosition(target: state.value!.markers.first.position, zoom: 15)));
      } else {
        setMiniMapStyle();
        if (!miniController.isCompleted) miniController.complete(controller);
      }
    });
  }

  Future<void> onStopChanged(int index) async {
    var pos = state.value!.markers.elementAtOrNull(index);
    if (pos != null) {
      GoogleMapController controller = await this.controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: pos.position, zoom: 15)));
    }
  }

  // Future<void> updateMap() async {
  //   GoogleMapController miniController = await this.miniController.future;
  //   state.whenData((value) {
  //     try {
  //       miniController.animateCamera(
  //           CameraUpdate.newLatLngBounds(repo.boundsFromLatLngList(value.markers.map((e) => e.position).toList()), 72));
  //     } catch (e) {
  //       miniController
  //           .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: value.markers.first.position)));
  //     }
  //   });
  // }

  Future<void> setMiniMapStyle() async {
    var mode = ref.read(themeHandlerProvider);
    final miniController = await this.miniController.future;
    if (mode == ThemeMode.system) {
      final theme = WidgetsBinding.instance.platformDispatcher.platformBrightness;

      if (theme == Brightness.dark) {
        miniController.setMapStyle(darkMapStyle);
      } else {
        miniController.setMapStyle(liteMapStyle);
      }
    } else {
      if (mode == ThemeMode.dark) {
        miniController.setMapStyle(darkMapStyle);
      } else {
        miniController.setMapStyle(liteMapStyle);
      }
    }
  }

  Future<void> setMapStyle() async {
    var mode = ref.read(themeHandlerProvider);
    final controller = await this.controller.future;
    if (mode == ThemeMode.system) {
      final theme = WidgetsBinding.instance.platformDispatcher.platformBrightness;

      if (theme == Brightness.dark) {
        controller.setMapStyle(darkMapStyle);
      } else {
        controller.setMapStyle(liteMapStyle);
      }
    } else {
      if (mode == ThemeMode.dark) {
        controller.setMapStyle(darkMapStyle);
      } else {
        controller.setMapStyle(liteMapStyle);
      }
    }
  }

  void setMapType() {
    var mapType = state.value!.mapType;
    state =
        AsyncValue.data(state.value!.copyWith(mapType: mapType == MapType.hybrid ? MapType.normal : MapType.hybrid));
  }
}

final mapProvider = AutoDisposeAsyncNotifierProviderFamily<MapNotifier, MapState, String>(MapNotifier.new);
