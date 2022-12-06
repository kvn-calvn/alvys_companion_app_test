// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
import 'package:alvys3/src/features/trips/presentation/trip/trip_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/app_trip/m_comodity.dart';

class StopDetailsPage extends ConsumerStatefulWidget {
  const StopDetailsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<StopDetailsPage> createState() => _StopDetailsPageState();
}

class _StopDetailsPageState extends ConsumerState<StopDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text('Stop Details'),
        centerTitle: true,
        leading: IconButton(
          // 1
          icon: Icon(
            Icons.adaptive.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
        elevation: 0,
      ),
      body: const StopDetails(),
    );
  }
}

class StopDetails extends ConsumerWidget {
  const StopDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stopDetailsState = ref.watch(tripPageControllerProvider);

    return stopDetailsState.when(
        loading: () => SpinKitFoldingCube(
              color: ColorManager.primary(Theme.of(context).brightness),
              size: 50.0,
            ),
        error: (error, stack) =>
            Text('Oops, something unexpected happened, $stack'),
        data: (value) {
          var currentStop = value.currentStop;
          return RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(tripPageControllerProvider.notifier)
                  .refreshCurrentTrip();
            },
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location',
                      style: getBoldStyle(color: ColorManager.darkgrey),
                    ),
                    Text(
                      currentStop.companyName ?? "",
                      style: getSemiBoldStyle(
                          color: ColorManager.darkgrey, fontSize: 14),
                    ),
                    Text(
                      currentStop.street ?? "",
                      style: getMediumStyle(
                          color: ColorManager.darkgrey, fontSize: 14),
                    ),
                    Text(
                      '${currentStop.city!} ${currentStop.state!} ${currentStop.zip!}',
                      style: getMediumStyle(
                          color: ColorManager.darkgrey, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact',
                          style: getBoldStyle(color: ColorManager.darkgrey),
                        ),
                        Text(
                          currentStop.phone ?? "",
                          style: getRegularStyle(
                              color: ColorManager.darkgrey, fontSize: 14),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Date',
                          style: getBoldStyle(color: ColorManager.darkgrey),
                        ),
                        Text(
                          currentStop.actualStopdate ?? "",
                          style: getRegularStyle(
                              color: ColorManager.darkgrey, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Check In',
                          style: getBoldStyle(color: ColorManager.darkgrey),
                        ),
                        Text(
                          currentStop.timeRecord?.driver?.driverIn ?? '',
                          style: getRegularStyle(
                              color: ColorManager.darkgrey, fontSize: 14),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Check Out',
                          style: getBoldStyle(color: ColorManager.darkgrey),
                        ),
                        Text(
                          currentStop.timeRecord?.driver?.out ?? '',
                          style: getRegularStyle(
                              color: ColorManager.darkgrey, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Items',
                  style: getBoldStyle(color: ColorManager.darkgrey),
                ),
                const SizedBox(height: 5),
                ItemsWidget(
                    commodities: currentStop.mComodities ?? <MComodity>[]),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Company Instruction',
                      style: getBoldStyle(color: ColorManager.darkgrey),
                    ),
                    Text(
                      currentStop.genInstructions ?? '',
                      style: getRegularStyle(
                          color: ColorManager.lightgrey, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stop Instruction',
                      style: getBoldStyle(color: ColorManager.darkgrey),
                    ),
                    Text(
                      currentStop.instructions ?? '',
                      style: getRegularStyle(
                          color: ColorManager.lightgrey, fontSize: 14),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}

class ItemsWidget extends StatelessWidget {
  const ItemsWidget({
    Key? key,
    required this.commodities,
  }) : super(key: key);

  final List<MComodity> commodities;

  @override
  Widget build(BuildContext context) {
    _items() {
      return commodities
          .map((item) => Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.description ?? '',
                      style: getRegularStyle(
                          color: ColorManager.darkgrey, fontSize: 14),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'UNITS',
                              style: getSemiBoldStyle(
                                  color: ColorManager.darkgrey, fontSize: 14),
                            ),
                            Text(
                              '${item.numUnits} ${item.unitType}',
                              style: getRegularStyle(
                                  color: ColorManager.darkgrey, fontSize: 14),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'PIECES',
                              style: getSemiBoldStyle(
                                  color: ColorManager.darkgrey, fontSize: 14),
                            ),
                            Text(
                              '${item.numPieces}',
                              style: getRegularStyle(
                                  color: ColorManager.darkgrey, fontSize: 14),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'WEIGHT',
                              style: getSemiBoldStyle(
                                  color: ColorManager.darkgrey, fontSize: 14),
                            ),
                            Text(
                              '${item.weight} ${item.weightType}',
                              style: getRegularStyle(
                                  color: ColorManager.darkgrey, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ))
          .toList();
    }

    return Column(
      children: [..._items()],
    );
  }
}
