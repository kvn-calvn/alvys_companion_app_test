import 'package:alvys3/src/common_widgets/large_nav_button.dart';
import 'package:alvys3/src/common_widgets/stop_card.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/features/trips/presentation/tripdetails/trip_details_controller.dart';
import 'package:alvys3/src/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadDetailsPage extends ConsumerStatefulWidget {
  const LoadDetailsPage({Key? key, required this.tripId}) : super(key: key);

  final String tripId;

  @override
  _LoadDetailsPageState createState() => _LoadDetailsPageState();
}

class _LoadDetailsPageState extends ConsumerState<LoadDetailsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    ref
        .read(tripDetailsControllerProvider.notifier)
        .getTripDetails(widget.tripId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          '1000047',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            textStyle: const TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
            /* borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,*/
            icon: const Icon(
              Icons.map_rounded,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              debugPrint('IconButton pressed ...');
            },
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF1F4F8),
      body: const TripDetails(),
    );
  }
}

class TripDetails extends ConsumerWidget {
  const TripDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripDetailsState = ref.watch(tripDetailsControllerProvider);

    return tripDetailsState.when(
        loading: () => SpinKitFoldingCube(
              color: ColorManager.primary,
              size: 50.0,
            ),
        error: (error, stack) =>
            Text('Oops, something unexpected happened, $stack'),
        data: (value) {
          var equipment =
              "${value!.data!.equipment} ${value.data!.equipmentLength}";
          var weight = "${value.data!.totalWeight}";
          var temp = "${value.data!.temperature}";
          var distance = "${value.data!.totalMiles}";
          var trailer = "${value.data!.trailerNum}";
          //var truck = "${value.data!.truckNum}";
          var pay = "${value.data!.paidMiles}";
          var tripId = value.data!.id!;

          var stops = value.data!.miniStops!;

          Widget _stopList() {
            if (stops.isNotEmpty) {
              return Column(
                children: [
                  ...stops.map((stop) => StopCard(stop: stop, tripId: tripId))
                ],
              );
            } else {
              return const Text("There are no stops on this trip.");
            }
          }

          return ListView(scrollDirection: Axis.vertical, children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LargeNavButton(
                      title: 'E-Checks',
                      route: Routes.echecksRoute,
                    ),
                    const LargeNavButton(
                      title: 'Documents',
                      route: Routes.echecksRoute,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              15, 10, 15, 0),
                          child: Wrap(
                            spacing: 5,
                            runSpacing: 8,
                            children: [
                              if (equipment != ' ') ...[
                                Chip(
                                    label: Text(equipment),
                                    backgroundColor: const Color(0xFFBBDEFB)),
                              ],
                              if (weight != ' ') ...[
                                Chip(
                                    label: Text(weight + 'lbs'),
                                    backgroundColor: const Color(0xFFBBDEFB)),
                              ],
                              if (temp != ' ') ...[
                                Chip(
                                    label: Text(temp + '°F'),
                                    backgroundColor: const Color(0xFFBBDEFB)),
                              ],
                              if (distance != ' ') ...[
                                Chip(
                                    label: Text(distance + 'mi'),
                                    backgroundColor: const Color(0xFFBBDEFB)),
                              ],
                              if (trailer != ' ') ...[
                                Chip(
                                    label: Text('Trailer ' + trailer),
                                    backgroundColor: const Color(0xFFBBDEFB)),
                              ],
                              if (pay != ' ') ...[
                                Chip(
                                    label: Text('Pay \$' + pay),
                                    backgroundColor: const Color(0xFFBBDEFB)),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    _stopList(),
                  ],
                ),
              ],
            )
          ]);
        });
  }
}
