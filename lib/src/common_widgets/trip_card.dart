import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart' as intl;

import '../features/authentication/presentation/auth_provider_controller.dart';
import '../features/trips/domain/app_trip/app_trip.dart';
import '../features/tutorial/tutorial_controller.dart';
import '../utils/dummy_data.dart';
import '../utils/magic_strings.dart';

class TripCard extends ConsumerWidget {
  const TripCard({Key? key, required this.trip}) : super(key: key);

  final AppTrip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var authState = ref.watch(authProvider);
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Material(
          key: trip.id == testTrip.id!
              ? ref.read(tutorialProvider).tripCard
              : null,
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          child: InkWell(
            onTap: () {
              context.goNamed(
                RouteName.tripDetails.name,
                pathParameters: {ParamType.tripId.name: trip.id!},
                queryParameters: {ParamType.tabIndex.name: 0.toString()},
              );
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
                          'Trip# ${trip.tripNumber} ${trip.companyCode}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        if (authState.value!
                            .shouldShowOOPRate(trip.companyCode!))
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
                                    '${trip.stops.firstOrNull?.address?.street ?? "-"} \n${trip.stops.firstOrNull?.address?.city ?? "-"}, ${trip.stops.firstOrNull?.address?.state ?? "-"} ${trip.stops.firstOrNull?.address?.zip ?? "-"}'
                                        .replaceAll(',', ', '),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                              ),
                              Text(
                                  trip.stops.firstOrNull?.formattedStopDate ??
                                      '',
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
                                      '${trip.stops.lastOrNull?.address?.street ?? "-"} \n${trip.stops.lastOrNull?.address?.city ?? "-"}, ${trip.stops.lastOrNull?.address?.state ?? "-"} ${trip.stops.lastOrNull?.address?.zip ?? "-"}'
                                          .replaceAll(',', ', '),
                                      maxLines: 2,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!,
                                    ),
                                  )),
                              Text(
                                  trip.stops.lastOrNull?.formattedStopDate ??
                                      '-',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TripCardDetail(
                          title: 'Deadhead',
                          details: trip.emptyMiles == null
                              ? '-'
                              : '${intl.NumberFormat.decimalPattern().format(trip.emptyMiles)} mi',
                        ),
                        const SizedBox(
                          height: 32,
                          child: VerticalDivider(
                            width: 10,
                          ),
                        ),
                        TripCardDetail(
                          title: 'trip',
                          details:
                              '${intl.NumberFormat.decimalPattern().format(trip.totalMiles)} mi',
                        ),
                        const SizedBox(
                          height: 32,
                          child: VerticalDivider(
                            width: 10,
                          ),
                        ),
                        TripCardDetail(
                          title: 'stops',
                          details: '${trip.stopCount}',
                        ),
                        const SizedBox(
                          height: 32,
                          child: VerticalDivider(
                            width: 10,
                          ),
                        ),
                        TripCardDetail(
                          title: 'weight',
                          details:
                              '${intl.NumberFormat.decimalPattern().format(trip.totalWeight ?? 0)} lbs',
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: Theme.of(context).textTheme.bodySmall),
        Text(
          details,
        ),
      ],
    );
  }
}
