import 'package:alvys3/src/features/authentication/presentation/auth_extension.dart';
import 'package:alvys3/src/utils/helpers.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/authentication/presentation/auth_provider_controller.dart';
import '../features/trips/domain/app_trip/app_trip.dart';
import '../features/trips/presentation/pages/stop_details_page.dart';
import '../features/tutorial/tutorial_controller.dart';
import '../utils/dummy_data.dart';
import '../utils/magic_strings.dart';

class TripCard extends ConsumerWidget {
  const TripCard({super.key, required this.trip});

  final AppTrip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var authState = ref.watch(authProvider);
    var authValue = authState.authValue;

    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Material(
          key: trip.id == testTrip.id! ? ref.read(tutorialProvider).tripCard : null,
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 5, 8),
                    child: Wrap(
                      runAlignment: WrapAlignment.spaceBetween,
                      alignment: WrapAlignment.spaceBetween,
                      runSpacing: 5,
                      children: [
                        Text(
                          'Trip# ${trip.tripNumber}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        if (authValue.shouldShowOOPRate(trip.companyCode!))
                          Text(
                            Helpers.fixedAmountDecimals(trip.tripValue ?? 0),
                            style: Theme.of(context).textTheme.bodyMedium,
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
                          Icons.arrow_upward_outlined,
                          color: Color(0XFFF08080),
                          size: 24,
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: constraints.maxWidth * 0.75,
                                ),
                                child: Text(
                                  trip.stops.firstOrNull?.tripCardAddress ?? "-",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: constraints.maxWidth * 0.8,
                                ),
                                child: StopDateDetails(
                                  args: trip.stops.firstOrNull?.formattedStopDate,
                                ),
                              )
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
                          padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: constraints.maxWidth * 0.75,
                                    ),
                                    child: Text(
                                      trip.stops.lastOrNull?.tripCardAddress ?? "-",
                                      maxLines: 2,
                                      style: Theme.of(context).textTheme.bodyLarge!,
                                    ),
                                  )),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: constraints.maxWidth * 0.8,
                                ),
                                child: StopDateDetails(
                                  args: trip.stops.lastOrNull?.formattedStopDate,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 5, 8),
                    child: Wrap(
                      runAlignment: WrapAlignment.spaceBetween,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        TripCardDetail(
                          title: 'd/h',
                          details: trip.emptyMiles == null
                              ? '-'
                              : '${Helpers.fixedDecimals(trip.emptyMiles!)} mi',
                        ),
                        const SizedBox(
                          height: 32,
                          child: VerticalDivider(
                            width: 10,
                            thickness: 0.1,
                          ),
                        ),
                        TripCardDetail(
                          title: 'trip',
                          details: trip.totalMiles.isNull
                              ? '-'
                              : '${Helpers.fixedDecimals(trip.totalMiles!)} mi',
                        ),
                        const SizedBox(
                          height: 32,
                          child: VerticalDivider(
                            width: 10,
                            thickness: 0.1,
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
                            thickness: 0.1,
                          ),
                        ),
                        TripCardDetail(
                          title: 'Wgt.',
                          details:
                              '${Helpers.fixedDecimals(trip.totalWeight ?? 0)} ${trip.loadWeightUnit ?? ''}',
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
    super.key,
    required this.title,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          details,
        ),
      ],
    );
  }
}
