// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:alvys3/src/common_widgets/large_nav_button.dart';
import 'package:alvys3/src/common_widgets/stop_card.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/features/trips/presentation/trip/trip_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/extensions.dart';

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
    final tripDetailsState = ref.watch(tripPageControllerProvider);

    return tripDetailsState.when(
        loading: () => SpinKitFoldingCube(
              color: ColorManager.primary,
              size: 50.0,
            ),
        error: (error, stack) =>
            Text('Oops, something unexpected happened, $stack'),
        data: (value) {
          var equipment =
              "${value.currentTrip.equipment} ${value.currentTrip.equipmentLength}";
          Widget _stopList() {
            if (value.currentTrip.stops!.isNotEmpty) {
              return Column(
                children: [
                  ...value.currentTrip.stops!
                      .map((stop) => StopCard(stop: stop, tripId: tripId))
                ],
              );
            } else {
              return const Text("There are no stops on this trip.");
            }
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(tripPageControllerProvider.notifier)
                  .refreshCurrentTrip();
            },
            child: ListView(scrollDirection: Axis.vertical, children: [
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
                            'tripNumber': value.currentTrip.tripNumber,
                            'tripId': value.currentTrip.id
                          });
                        },
                      ),
                      LargeNavButton(
                        title: 'Documents',
                        onPressed: () {
                          context.pushNamed('tripDocs', queryParams: {
                            'tripNumber': value.currentTrip.tripNumber,
                            'tripId': value.currentTrip.id
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
                              runSpacing: 5,
                              children: [
                                if (equipment.isNotNullOrEmpty) ...[
                                  Chip(
                                      label: Text(value.currentTrip.equipment!),
                                      backgroundColor: const Color(0xFFBBDEFB)),
                                ],
                                if (value.currentTrip.totalWeight != null) ...[
                                  Chip(
                                      label: Text(
                                          '${value.currentTrip.totalWeight}lbs'),
                                      backgroundColor: const Color(0xFFBBDEFB)),
                                ],
                                if (value.currentTrip.temperature != null) ...[
                                  Chip(
                                      label: Text(
                                          '${value.currentTrip.temperature!.toStringAsFixed(2)}°F'),
                                      backgroundColor: const Color(0xFFBBDEFB)),
                                ],
                                if (value.currentTrip.totalMiles != null) ...[
                                  Chip(
                                      label: Text(
                                          '${value.currentTrip.totalMiles!.toStringAsFixed(2)} mi'),
                                      backgroundColor: const Color(0xFFBBDEFB)),
                                ],
                                if (value.currentTrip.trailerNum
                                    .isNotNullOrEmpty) ...[
                                  Chip(
                                      label: Text(
                                          'Trailer ${value.currentTrip.trailerNum}'),
                                      backgroundColor: const Color(0xFFBBDEFB)),
                                ],
                                if (value.currentTrip.paidMiles != null) ...[
                                  Chip(
                                      label: Text(
                                          'Pay \$${value.currentTrip.paidMiles!.toStringAsFixed(2)}'),
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
            ]),
          );
        });
  }
}
