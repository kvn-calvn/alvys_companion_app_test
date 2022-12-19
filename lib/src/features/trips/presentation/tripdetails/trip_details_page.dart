// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:alvys3/src/common_widgets/large_nav_button.dart';
import 'package:alvys3/src/common_widgets/stop_card.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/features/trips/presentation/trip/trip_page_controller.dart';
import 'package:alvys3/src/utils/app_theme.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/extensions.dart';

class LoadDetailsPage extends ConsumerStatefulWidget {
  const LoadDetailsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoadDetailsPageState createState() => _LoadDetailsPageState();
}

class _LoadDetailsPageState extends ConsumerState<LoadDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var trip = ref.watch(tripPageControllerProvider).value!.currentTrip;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          trip.tripNumber ?? '',
          style: AlvysTheme.appbarTextStyle(context, true),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.adaptive.arrow_back,
          ),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.map_rounded,
            ),
            onPressed: () {
              debugPrint('IconButton pressed ...');
            },
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: TripDetails(),
      ),
    );
  }
}

class TripDetails extends ConsumerWidget {
  const TripDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripDetailsState = ref.watch(tripPageControllerProvider);

    return tripDetailsState.when(
      loading: () => SpinKitFoldingCube(
        color: ColorManager.primary(Theme.of(context).brightness),
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
                ...value.currentTrip.stops!.map((stop) =>
                    StopCard(stop: stop, tripId: value.currentTrip.id!))
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
                        context.pushNamed(RouteName.eCheck.name);
                      },
                    ),
                    LargeNavButton(
                      title: 'Documents',
                      onPressed: () {
                        context.pushNamed(RouteName.tripDocuments.name,
                            queryParams: {
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
                                  label: Text(
                                    value.currentTrip.equipment!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  backgroundColor: const Color(0xFFBBDEFB),
                                ),
                              ],
                              if (value.currentTrip.totalWeight != null) ...[
                                Chip(
                                  label: Text(
                                    '${value.currentTrip.totalWeight}lbs',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  backgroundColor: const Color(0xFFBBDEFB),
                                ),
                              ],
                              if (value.currentTrip.temperature != null) ...[
                                Chip(
                                    label: Text(
                                      '${value.currentTrip.temperature!.toStringAsFixed(2)}°F',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                    ),
                                    backgroundColor: const Color(0xFFBBDEFB)),
                              ],
                              if (value.currentTrip.totalMiles != null) ...[
                                Chip(
                                  label: Text(
                                    '${value.currentTrip.totalMiles!.toStringAsFixed(2)} mi',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: const Color(0xFFBBDEFB),
                                ),
                              ],
                              if (value
                                  .currentTrip.trailerNum.isNotNullOrEmpty) ...[
                                Chip(
                                  label: Text(
                                    'Trailer ${value.currentTrip.trailerNum}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: const Color(0xFFBBDEFB),
                                ),
                              ],
                              if (value.currentTrip.paidMiles != null) ...[
                                Chip(
                                  label: Text(
                                    'Pay \$${value.currentTrip.paidMiles!.toStringAsFixed(2)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: const Color(0xFFBBDEFB),
                                ),
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
      },
    );
  }
}
