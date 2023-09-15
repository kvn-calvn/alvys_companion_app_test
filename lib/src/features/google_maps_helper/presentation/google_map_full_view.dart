import 'full_map_stop_card.dart';
import 'map_controller.dart';
import '../../../utils/tablet_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../trips/domain/app_trip/stop.dart';

class FullScreenMap extends ConsumerWidget {
  final String tripId;
  const FullScreenMap(this.tripId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mapState = ref.watch(mapProvider.call(tripId));
    var mapNotifier = ref.read(mapProvider.call(tripId).notifier);
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => mapNotifier.onMapCreated(controller, true),
            markers: mapState.value?.markers ?? {},
            polylines: mapState.value?.polyLines ?? {},
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.0902, -95.7129),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.05,
            left: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.longestSide * 0.16,
              child: MapStopsView(mapNotifier.trips.value!.getTrip(tripId).stops, tripId),
            ),
          )
        ],
      ),
    );
  }
}

class MapStopsView extends ConsumerStatefulWidget {
  const MapStopsView(this.stops, this.tripId, {super.key});
  final List<Stop>? stops;
  final String tripId;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapStopsViewState();
}

class _MapStopsViewState extends ConsumerState<MapStopsView> {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(viewportFraction: TabletUtils.instance.isTablet ? 0.55 : 0.7);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: pageController,
        itemCount: widget.stops?.length ?? 0,
        onPageChanged: ref.read(mapProvider.call(widget.tripId).notifier).onStopChanged,
        itemBuilder: (context, index) {
          var stop = widget.stops![index];
          return FullMapStopCard(stop);
        });
  }
}
