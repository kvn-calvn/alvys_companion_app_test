import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../utils/map_styles.dart';
import '../../../utils/tablet_utils.dart';
import '../../trips/domain/app_trip/stop.dart';
import 'full_map_stop_card.dart';
import 'map_controller.dart';

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
            onMapCreated: (controller) {
              mapNotifier.onMapCreated(controller, true);
            },
            mapType: mapState.value!.mapType,
            markers: mapState.value?.markers ?? {},
            polylines: mapState.value?.polyLines ?? {},
            style: getMapStyle(context),
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.0902, -95.7129),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: SafeArea(
              child: Column(
                children: [
                  MapButton(icon: Icons.adaptive.arrow_back, onTap: Navigator.of(context).pop),
                  MapButton(icon: Icons.map, onTap: mapNotifier.setMapType),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.05,
            left: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.longestSide * 0.2,
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

class MapButton extends StatelessWidget {
  final IconData icon;
  final void Function() onTap;

  const MapButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        shape: const CircleBorder(),
        constraints: const BoxConstraints(),
        fillColor: Theme.of(context).cardColor,
        onPressed: onTap,
        padding: const EdgeInsets.all(8),
        child: Icon(icon));
  }
}
