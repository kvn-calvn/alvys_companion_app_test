// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:alvys3/src/common_widgets/large_nav_button.dart';
import 'package:alvys3/src/common_widgets/stop_card.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/features/trips/presentation/tripdetails/trip_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadDetailsPage extends ConsumerStatefulWidget {
  const LoadDetailsPage(
      {Key? key, required this.tripId, required this.tripNumber})
      : super(key: key);

  final String tripId;
  final String? tripNumber;

  @override
  // ignore: library_private_types_in_public_api
  _LoadDetailsPageState createState() => _LoadDetailsPageState();
}

class _LoadDetailsPageState extends ConsumerState<LoadDetailsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          widget.tripNumber ?? '',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            textStyle: const TextStyle(color: Colors.black),
          ),
        ),
        leading: IconButton(
          // 1
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
          color: ColorManager.darkgrey,
          onPressed: () {
            //Navigator.of(context).maybePop();
            GoRouter.of(context).pop();
          },
        ),
        actions: [
          IconButton(
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
      body: TripDetails(tripId: widget.tripId),
    );
  }
}

class TripDetails extends ConsumerWidget {
  final String tripId;

  const TripDetails({Key? key, required this.tripId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripDetailsState = ref.watch(getTripDetailsProvider(tripId));

    return tripDetailsState.when(
        loading: () => SpinKitFoldingCube(
              color: ColorManager.primary,
              size: 50.0,
            ),
        error: (error, stack) =>
            Text('Oops, something unexpected happened, $stack'),
        data: (value) {
          final data = value.data!.data!;
          var equipment = "${data.equipment} ${data.equipmentLength}";
          var weight = "${data.totalWeight}";
          var temp = "${data.temperature}";
          var distance = "${data.totalMiles}";
          var trailer = "${data.trailerNum}";
          //var truck = "${value.data!.truckNum}";
          var pay = "${data.paidMiles}";
          var tripId = data.id!;
          var loadNum = data.tripNumber!;

          var stops = data.miniStops!;

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
                    LargeNavButton(
                      title: 'E-Checks',
                      onPressed: () {
                        context.pushNamed('echeck', queryParams: {
                          'tripNumber': loadNum,
                          'tripId': tripId
                        });
                      },
                    ),
                    LargeNavButton(
                      title: 'Documents',
                      onPressed: () {
                        context.pushNamed('tripDocs', queryParams: {
                          'tripNumber': loadNum,
                          'tripId': tripId
                        });
                      },
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
                                    label: Text('${weight}lbs'),
                                    backgroundColor: const Color(0xFFBBDEFB)),
                              ],
                              if (temp != ' ') ...[
                                Chip(
                                    label: Text('$temp°F'),
                                    backgroundColor: const Color(0xFFBBDEFB)),
                              ],
                              if (distance != ' ') ...[
                                Chip(
                                    label: Text('${distance}mi'),
                                    backgroundColor: const Color(0xFFBBDEFB)),
                              ],
                              if (trailer != ' ') ...[
                                Chip(
                                    label: Text('Trailer $trailer'),
                                    backgroundColor: const Color(0xFFBBDEFB)),
                              ],
                              if (pay != ' ') ...[
                                Chip(
                                    label: Text('Pay \$$pay'),
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
