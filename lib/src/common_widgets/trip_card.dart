//import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/features/trips/presentation/trip/trip_page_controller.dart';
import 'package:alvys3/src/utils/extensions.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../features/trips/domain/app_trip/app_trip.dart';

class TripCard extends ConsumerWidget {
  const TripCard({Key? key, required this.trip}) : super(key: key);

  final AppTrip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Material(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: InkWell(
            onTap: () {
              ref
                  .read(tripPageControllerProvider.notifier)
                  .setCurrentTrip(trip.id!);
              context.pushNamed(RouteName.tripDetails.name);
            },
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
                        Text(
                          'Trip# ${trip.tripNumber}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                            NumberFormat.simpleCurrency()
                                .format(trip.tripValue),
                            style: Theme.of(context).textTheme.bodyMedium),
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
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: constraints.maxWidth * 0.75,
                                ),
                                child: Text(
                                    '${trip.firstStopAddress}'
                                        .replaceAll(',', ', '),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                              ),
                              Text(
                                  DateFormat('MMM d @ h:mm a', 'en_US')
                                      .formatNullDate(trip.pickupDate),
                                  style:
                                      Theme.of(context).textTheme.bodyMedium!),
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
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: constraints.maxWidth * 0.75,
                                    ),
                                    child: Text(
                                      '${trip.lastStopAddress}'
                                          .replaceAll(',', ', '),
                                      maxLines: 2,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!,
                                    ),
                                  )),
                              Text(
                                  DateFormat('MMM d @ h:mm a', 'en_US')
                                      .formatNullDate(trip.deliveryDate),
                                  style:
                                      Theme.of(context).textTheme.bodyMedium!),
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
                        const TripCardDetail(
                          title: 'dh',
                          details: '0.00 mi',
                        ),
                        TripCardDetail(
                          title: 'trip',
                          details: '${trip.totalMiles!.toStringAsFixed(2)} mi',
                        ),
                        TripCardDetail(
                          title: 'stops',
                          details: '${trip.stopCount}',
                        ),
                        TripCardDetail(
                          title: 'weight',
                          details: '${trip.totalWeight} lbs',
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
    });
  }
}

class TripCardDetail extends StatelessWidget {
  final String details, title;
  const TripCardDetail({
    Key? key,
    required this.title,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title.toUpperCase(), style: Theme.of(context).textTheme.caption),
        Text(
          details,
        ),
      ],
    );
  }
}
