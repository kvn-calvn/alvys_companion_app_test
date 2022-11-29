// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:alvys3/src/common_widgets/trip_card.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
import 'package:flutter/material.dart';

class FilteredTripPage extends StatelessWidget {
  const FilteredTripPage({Key? key, required this.trips, required this.title})
      : super(key: key);

  final dynamic trips;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: const [],
        centerTitle: true,
        elevation: 0,
        title: Text(
          title,
          style: getBoldStyle(color: ColorManager.darkgrey, fontSize: 20),
        ),
        leading: IconButton(
          // 1
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
          color: ColorManager.darkgrey,
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
      ),
      backgroundColor: const Color(0xFFF1F4F8),
      body: SafeArea(child: TripList(trips: trips, title: title)),
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
              style: getMediumStyle(color: ColorManager.lightgrey),
            )
          ],
        ),
      );
    }
  }
}
