import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common_widgets/empty_view.dart';
import '../../../../common_widgets/trip_card.dart';
import '../../../../utils/alvys_websocket.dart';
import '../../../../utils/magic_strings.dart';
import '../controller/trip_page_controller.dart';

class FilteredTripPage extends ConsumerWidget {
  const FilteredTripPage({Key? key, required this.filterType}) : super(key: key);

  final TripFilterType filterType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var trips = filterType == TripFilterType.delivered
        ? ref.watch(tripControllerProvider).value!.deliveredTrips
        : ref.watch(tripControllerProvider).value!.processingTrips;
    return Scaffold(
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: () async {
          await ref.read(tripControllerProvider.notifier).refreshTrips();
          ref.read(websocketProvider).restartConnection();
        },
        child: trips.isNotEmpty
            ? ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                scrollDirection: Axis.vertical,
                children: trips.map((trip) => TripCard(trip: trip)).toList(),
              )
            : filterType == TripFilterType.processing
                ? const EmptyView(title: '', description: "There are no trips being processed.")
                : EmptyView(title: '', description: "There are no ${filterType.name} trips."),
      )),
    );
  }
}

class TripList extends StatelessWidget {
  const TripList({
    Key? key,
    required this.trips,
    required this.title,
  }) : super(key: key);

  final dynamic trips;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (trips.isNotEmpty) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        scrollDirection: Axis.vertical,
        children: trips.map((trip) => TripCard(trip: trip)),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "There are no ${title.toLowerCase()} trips.",
              style: Theme.of(context).textTheme.labelLarge,
            )
          ],
        ),
      );
    }
  }
}
