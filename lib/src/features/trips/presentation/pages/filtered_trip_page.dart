import 'package:alvys3/src/common_widgets/shimmers/trip_card_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common_widgets/empty_view.dart';
import '../../../../common_widgets/trip_card.dart';
import '../../../../utils/alvys_websocket.dart';
import '../../../../utils/magic_strings.dart';
import '../controller/trip_page_controller.dart';

class FilteredTripPage extends ConsumerWidget {
  const FilteredTripPage({super.key, required this.filterType});

  final TripFilterType filterType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsState = ref.watch(tripControllerProvider);
    if (tripsState.isLoading) return const TripListShimmer();
    var trips = filterType == TripFilterType.delivered
        ? ref.watch(tripControllerProvider).value!.deliveredTrips
        : ref.watch(tripControllerProvider).value!.processingTrips;
    return Scaffold(
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: () async {
          await ref.read(tripControllerProvider.notifier).refreshTrips();
          if (context.mounted) ref.read(websocketProvider).restartConnection();
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
    super.key,
    required this.trips,
    required this.title,
  });

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
