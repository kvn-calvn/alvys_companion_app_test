// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:alvys3/src/common_widgets/large_nav_button.dart';
import 'package:alvys3/src/common_widgets/stop_card.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/features/documents/presentation/document_page.dart';
import 'package:alvys3/src/features/documents/presentation/trip_docs_controller.dart';
import 'package:alvys3/src/features/echeck/presentation/pages/echeck_page.dart';
import 'package:alvys3/src/features/trips/presentation/controller/trip_page_controller.dart';
import 'package:alvys3/src/utils/app_theme.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LoadDetailsPage extends ConsumerStatefulWidget {
  final String tripId;

  const LoadDetailsPage(this.tripId, {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoadDetailsPageState createState() => _LoadDetailsPageState();
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
        DocumentsPage(DocumentsArgs(DocumentType.tripDocuments, widget.tripId)),
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
                ...trip.stops!.map((stop) => StopCard(
                      stop: stop,
                      tripId: trip.id!,
                      canCheckInOut: trip.stops?.firstWhereOrNull((element) =>
                              element.timeRecord?.driver?.timeIn != null ||
                              element.timeRecord?.driver?.timeOut != null) !=
                          null,
                    ))
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
                        style: Theme.of(context).textTheme.bodyMedium)
                  ],
                ),
              ),
            );
          }
        }

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
                                            .bodyMedium!,
                                      ),
                                      backgroundColor: ColorManager.chipColor(
                                          Theme.of(context).brightness),
                                    ),
                                  ],
                                  if (trip.totalWeight != null) ...[
                                    Chip(
                                      label: Text(
                                        '${trip.totalWeight}lbs',
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
                                        '${trip.temperature!.toStringAsFixed(2)}°F',
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
                                        '${trip.totalMiles!.toStringAsFixed(2)} mi',
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
                                        'Pay \$${trip.paidMiles!.toStringAsFixed(2)}',
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
