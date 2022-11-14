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
    _filteredTrips() {
      return trips.map((trip) => TripCard(trip: trip));
    }

    debugPrint("Hello");
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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          scrollDirection: Axis.vertical,
          children: [
            if (trips.isNotEmpty) ...[
              Column(
                children: [..._filteredTrips()],
              )
              //
            ] else ...[
              Text("There are no $title loads")
            ],
          ],
        ),
      ),
    );
  }
}
