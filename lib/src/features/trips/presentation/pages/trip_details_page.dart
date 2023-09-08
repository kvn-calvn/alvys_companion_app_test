import 'package:alvys3/src/common_widgets/shimmers/trip_details_shimmer.dart';

import '../../../../common_widgets/stop_card.dart';
import '../../../../constants/color.dart';
import '../../../echeck/presentation/pages/echeck_page.dart';
import '../controller/trip_page_controller.dart';
import 'trip_documents_page.dart';
import '../../../../utils/app_theme.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LoadDetailsPage extends ConsumerStatefulWidget {
  final String tripId;

  const LoadDetailsPage(this.tripId, {Key? key}) : super(key: key);

  @override
  ConsumerState<LoadDetailsPage> createState() => _LoadDetailsPageState();
}

class _LoadDetailsPageState extends ConsumerState<LoadDetailsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var trip = ref.watch(tripControllerProvider).value!.getTrip(widget.tripId);
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
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          onTap: (value) {
            /*if (functions.isLoading)
                  setState(() => tabController.index = 0);*/
          },
          tabs: const <Widget>[
            Tab(
              text: 'Details',
            ),
            Tab(
              text: 'E-Checks',
            ),
            Tab(
              text: 'Documents',
            )
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        TripDetails(widget.tripId),
        EcheckPage(widget.tripId),
        TripDocuments(widget.tripId)
        // DocumentsPage(DocumentsArgs(DocumentType.tripDocuments, widget.tripId)),
      ]),
    );
  }
}

class TripDetails extends ConsumerWidget {
  final String tripId;
  const TripDetails(this.tripId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripDetailsState = ref.watch(tripControllerProvider);
    // return TripDetailsShimmer();
    return tripDetailsState.when(
      loading: () => const TripDetailsShimmer(),
      error: (error, stack) =>
          Text('Oops, something unexpected happened, $stack'),
      data: (value) {
        var trip = value.getTrip(tripId);
        var equipment = "${trip.equipment} ${trip.equipmentLength}";

        return RefreshIndicator(
          onRefresh: () async {
            await ref
                .read(tripControllerProvider.notifier)
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
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                tilt: 90,
                                target: LatLng(37.6, -95.665),
                                zoom: 13.4,
                              ),
                              mapToolbarEnabled: false,
                              rotateGesturesEnabled: false,
                              scrollGesturesEnabled: false,
                              tiltGesturesEnabled: false,
                              zoomGesturesEnabled: false,
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                              compassEnabled: false,
                              mapType: MapType.normal,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 15, 0),
                              child: Wrap(
                                spacing: 5,
                                runSpacing: 5,
                                children: [
                                  if (equipment.isNotNullOrEmpty) ...[
                                    Chip(
                                      label: Text(
                                        '${trip.equipment!} ${trip.equipmentLength ?? ''}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!,
                                      ),
                                      backgroundColor: ColorManager.chipColor(
                                          Theme.of(context).brightness),
                                    ),
                                  ],
                                  if (trip.totalWeight != null) ...[
                                    Chip(
                                      label: Text(
                                        '${intl.NumberFormat.decimalPattern().format(trip.totalWeight)} lbs',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!,
                                      ),
                                      backgroundColor: ColorManager.chipColor(
                                          Theme.of(context).brightness),
                                    ),
                                  ],
                                  if (trip.temperature != null) ...[
                                    Chip(
                                      label: Text(
                                        '${trip.temperature!.toStringAsFixed(1)} °f',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!,
                                      ),
                                      backgroundColor: ColorManager.chipColor(
                                          Theme.of(context).brightness),
                                    ),
                                  ],
                                  if (trip.totalMiles != null) ...[
                                    Chip(
                                      label: Text(
                                        '${intl.NumberFormat.decimalPattern().format(trip.totalMiles)} mi',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!,
                                      ),
                                      backgroundColor: ColorManager.chipColor(
                                          Theme.of(context).brightness),
                                    ),
                                  ],
                                  if (trip.trailerNum.isNotNullOrEmpty) ...[
                                    Chip(
                                      label: Text(
                                        'Trailer ${trip.trailerNum}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!,
                                      ),
                                      backgroundColor: ColorManager.chipColor(
                                          Theme.of(context).brightness),
                                    ),
                                  ],
                                  if (trip.paidMiles != null) ...[
                                    Chip(
                                      label: Text(
                                        'Pay ${intl.NumberFormat.simpleCurrency().format(trip.paidMiles)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!,
                                      ),
                                      backgroundColor: ColorManager.chipColor(
                                          Theme.of(context).brightness),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (trip.stops.isNullOrEmpty) ...{
                          Center(
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
                                    style:
                                        Theme.of(context).textTheme.bodyMedium)
                              ],
                            ),
                          ),
                        } else ...{
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ...trip.stops!.map((stop) => StopCard(
                                    stop: stop,
                                    tripId: trip.id!,
                                    canCheckInOutStopId:
                                        trip.canCheckInOutStopId,
                                  ))
                            ],
                          ),
                        }
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
