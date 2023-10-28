import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../network/http_client.dart';
import 'google_map_full_view.dart';
import 'map_controller.dart';

class TripGoogleMap extends ConsumerStatefulWidget {
  final String tripId;
  const TripGoogleMap(this.tripId, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TripGoogleMapState();
}

class _TripGoogleMapState extends ConsumerState<TripGoogleMap> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    var mapNotifier = ref.read(mapProvider.call(widget.tripId).notifier);
    mapNotifier.setMapStyle().then((value) => mapNotifier.setMiniMapStyle());
  }

  @override
  Widget build(BuildContext context) {
    var mapState = ref.watch(mapProvider.call(widget.tripId));
    return SizedBox(
      height: 200,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
        child: Center(
          child: GoogleMap(
            onTap: (argument) async {
              if (!mapState.isLoading) {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => FullScreenMap(widget.tripId)),
                );

                ref.read(httpClientProvider).telemetryClient.trackEvent(name: "open_map");
                await FirebaseAnalytics.instance.logEvent(name: "open_map");
              }
            },
            onMapCreated: (controller) =>
                ref.read(mapProvider.call(widget.tripId).notifier).onMapCreated(controller, false),
            initialCameraPosition: const CameraPosition(
              tilt: 20,
              target: LatLng(37.6, -95.665),
              zoom: 3,
            ),
            markers: mapState.value?.markers ?? {},
            polylines: mapState.value?.polyLines ?? {},
            mapToolbarEnabled: false,
            rotateGesturesEnabled: false,
            scrollGesturesEnabled: false,
            tiltGesturesEnabled: false,
            zoomGesturesEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            mapType: MapType.normal,
          ),
        ),
      ),
    );
  }
}
