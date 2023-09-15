import 'google_map_full_view.dart';
import 'map_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripGoogleMap extends ConsumerWidget {
  final String tripId;
  const TripGoogleMap(this.tripId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mapState = ref.watch(mapProvider.call(tripId));
    var mapNotifier = ref.read(mapProvider.call(tripId).notifier);
    return SizedBox(
      height: 200,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
        child: GoogleMap(
          onTap: (argument) {
            if (!mapState.isLoading) {
              Navigator.of(context, rootNavigator: true)
                  .push(MaterialPageRoute(builder: (context) => FullScreenMap(tripId)));
            }
          },
          onMapCreated: (controller) => mapNotifier.onMapCreated(controller, false),
          initialCameraPosition: const CameraPosition(
            tilt: 20,
            target: LatLng(37.6, -95.665),
            zoom: 5,
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
    );
  }
}
