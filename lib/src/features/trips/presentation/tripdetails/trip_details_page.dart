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

import 'package:alvys3/src/utils/extensions.dart';

class LoadDetailsPage extends ConsumerStatefulWidget {
  final String tripId;
  const LoadDetailsPage(this.tripId, {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoadDetailsPageState createState() => _LoadDetailsPageState();
}

class _LoadDetailsPageState extends ConsumerState<LoadDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var trip =
        ref.watch(tripPageControllerProvider).value!.getTrip(widget.tripId);
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: TripDetails(widget.tripId),
      ),
    );
  }
}

class TripDetails extends ConsumerWidget {
  final String tripId;
  const TripDetails(this.tripId, {Key? key}) : super(key: key);

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
        var trip = value.getTrip(tripId);
        var equipment = "${trip.equipment} ${trip.equipmentLength}";
        Widget _stopList() {
          if (trip.stops!.isNotEmpty) {
            return Column(
              children: [
                ...trip.stops!
                    .map((stop) => StopCard(stop: stop, tripId: trip.id!))
              ],
            );
          } else {
            return Container(
              alignment: Alignment.center,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Text(
                      "No Stops",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text("There are no stops on this trip.",
                        style: Theme.of(context).textTheme.bodyText2)
                  ],
                ),
              ),
            );
          }
        }

        return RefreshIndicator(
          onRefresh: () async {
            await ref
                .read(tripPageControllerProvider.notifier)
                .refreshCurrentTrip(tripId);
          },
          child: ListView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
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
                            context.goNamed(RouteName.eCheck.name,
                                params: {ParamType.tripId.name: tripId});
                          },
                        ),
                        LargeNavButton(
                          title: 'Documents',
                          onPressed: () {
                            context.goNamed(RouteName.tripDocumentList.name,
                                params: {ParamType.tripId.name: trip.id!});
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
                                        trip.equipment!,
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
                                  if (trip.totalWeight != null) ...[
                                    Chip(
                                      label: Text(
                                        '${trip.totalWeight}lbs',
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
                                  if (trip.temperature != null) ...[
                                    Chip(
                                        label: Text(
                                          '${trip.temperature!.toStringAsFixed(2)}°F',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        backgroundColor:
                                            const Color(0xFFBBDEFB)),
                                  ],
                                  if (trip.totalMiles != null) ...[
                                    Chip(
                                      label: Text(
                                        '${trip.totalMiles!.toStringAsFixed(2)} mi',
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
                                  if (trip.trailerNum.isNotNullOrEmpty) ...[
                                    Chip(
                                      label: Text(
                                        'Trailer ${trip.trailerNum}',
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
                                  if (trip.paidMiles != null) ...[
                                    Chip(
                                      label: Text(
                                        'Pay \$${trip.paidMiles!.toStringAsFixed(2)}',
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
