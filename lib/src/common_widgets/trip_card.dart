import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
import 'package:alvys3/src/features/trips/domain/trips/datum.dart';
import 'package:alvys3/src/routing/routes.dart';
import 'package:alvys3/src/routing/routing_arguments.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class TripCard extends StatelessWidget {
  const TripCard({Key? key, required this.trip}) : super(key: key);

  final Datum trip;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /* final args = TripDetailsArguments(
            tripId: trip.id!, tripNumber: trip.tripNumber!);
        Navigator.pushNamed(context, Routes.tripDetailsRoute, arguments: args);*/

        context.goNamed(
          'tripDetails',
          queryParams: <String, String>{
            'tripNumber': trip.tripNumber!,
            'tripId': trip.id!
          },
        );
/*
        context.go('/trips/tripdetails/${trip.id!}',
            extra: {"tripNumber": trip.tripNumber!});*/
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 2,
                color: Color(0x3416202A),
                offset: Offset(0, 1),
              )
            ],
            borderRadius: BorderRadius.circular(12),
            shape: BoxShape.rectangle,
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(15, 5, 15, 5),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 5, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Trip# ${trip.tripNumber}',
                          style: getMediumStyle(
                              color: ColorManager.darkgrey, fontSize: 14)),
                      Text(NumberFormat.simpleCurrency().format(trip.tripValue),
                          style: getMediumStyle(
                              color: ColorManager.darkgrey, fontSize: 14)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.arrow_upward_outlined,
                        color: Color(0XFFF08080),
                        size: 24,
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${trip.firstStopAddress}',
                                style: getBoldStyle(
                                    color: ColorManager.darkgrey,
                                    fontSize: 14)),
                            Text(
                                DateFormat('MMM d @ h:mm a', 'en_US')
                                    .format(trip.pickupDate!),
                                style: getMediumStyle(
                                    color: ColorManager.darkgrey,
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.arrow_downward_outlined,
                        color: Color(0XFF2991C2),
                        size: 24,
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 10, 0),
                                child: Wrap(
                                  children: [
                                    Text(
                                      '${trip.lastStopAddress}',
                                      maxLines: 2,
                                      style: getBoldStyle(
                                          color: ColorManager.darkgrey,
                                          fontSize: 14),
                                    ),
                                  ],
                                )),
                            Text(
                                DateFormat('MMM d @ h:mm a', 'en_US')
                                    .format(trip.deliveryDate!),
                                style: getMediumStyle(
                                    color: ColorManager.darkgrey,
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 5, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'DH',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Text('0.00 mi',
                              style: getMediumStyle(
                                  color: ColorManager.darkgrey, fontSize: 12)),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'TRIP',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                              '${double.parse((trip.totalMiles)!.toStringAsFixed(2))} mi',
                              style: getMediumStyle(
                                  color: ColorManager.darkgrey, fontSize: 12)),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'STOPS',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Text('${trip.stopCount}',
                              style: getMediumStyle(
                                  color: ColorManager.darkgrey, fontSize: 12)),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'WEIGHT',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Text('${trip.totalWeight} lbs',
                              style: getMediumStyle(
                                  color: ColorManager.darkgrey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
