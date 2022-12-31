// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:alvys3/src/common_widgets/empty_view.dart';
import 'package:alvys3/src/common_widgets/trip_card.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/features/trips/presentation/trip/trip_page_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../utils/extensions.dart';
import 'package:flutter/material.dart';

import '../../../../utils/magic_strings.dart';

class FilteredTripPage extends ConsumerWidget {
  const FilteredTripPage({Key? key, required this.filterType})
      : super(key: key);

  final TripFilterType filterType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var trips = filterType == TripFilterType.delivered
        ? ref.watch(tripPageControllerProvider).value!.deliveredTrips
        : ref.watch(tripPageControllerProvider).value!.processingTrips;
    return Scaffold(
      key: key,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          filterType.toTitleCase,
        ),
        leading: IconButton(
          // 1
          icon: Icon(
            Icons.adaptive.arrow_back,
          ),
          color: ColorManager.greyColorScheme1(Theme.of(context).brightness),
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
      ),
      //backgroundColor: const Color(0xFFF1F4F8),
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: () async {
          await ref.read(tripPageControllerProvider.notifier).refreshTrips();
        },
        child: trips.isNotEmpty
            ? ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                scrollDirection: Axis.vertical,
                children: trips.map((trip) => TripCard(trip: trip)).toList(),
              )
            : EmptyView(
                title: '',
                description: "There are no ${filterType.name} trips."),
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
    _filteredTrips() {
      return trips.map((trip) => TripCard(trip: trip));
    }

    if (trips.isNotEmpty) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        scrollDirection: Axis.vertical,
        children: [..._filteredTrips()],
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
