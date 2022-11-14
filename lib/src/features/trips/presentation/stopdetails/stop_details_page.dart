import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
import 'package:alvys3/src/features/trips/domain/stop_details/m_comodity.dart';
import 'package:alvys3/src/features/trips/presentation/stopdetails/stop_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StopDetailsPage extends ConsumerStatefulWidget {
  const StopDetailsPage({Key? key, required this.tripId, required this.stopId})
      : super(key: key);

  final String tripId;
  final String stopId;

  @override
  ConsumerState<StopDetailsPage> createState() => _StopDetailsPageState();
}

class _StopDetailsPageState extends ConsumerState<StopDetailsPage> {
  //final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    ref
        .read(stopDetailsControllerProvider.notifier)
        .getStopDetails(widget.tripId, widget.stopId);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.stopId + ' ' + widget.tripId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          'Stop Details',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            textStyle: const TextStyle(color: Colors.black),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          // 1
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
          color: ColorManager.darkgrey,
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF1F4F8),
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
    final stopDetailsState = ref.watch(stopDetailsControllerProvider);

    return stopDetailsState.when(
        loading: () => SpinKitFoldingCube(
              color: ColorManager.primary,
              size: 50.0,
            ),
        error: (error, stack) =>
            Text('Oops, something unexpected happened, $stack'),
        data: (value) {
          return ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location',
                    style: getBoldStyle(color: ColorManager.darkgrey),
                  ),
                  Text(
                    value!.data?.companyName ?? "",
                    style: getSemiBoldStyle(
                        color: ColorManager.darkgrey, fontSize: 14),
                  ),
                  Text(
                    value.data!.street ?? "",
                    style: getMediumStyle(
                        color: ColorManager.darkgrey, fontSize: 14),
                  ),
                  Text(
                    value.data!.city! +
                        ' ' +
                        value.data!.state! +
                        ' ' +
                        value.data!.zip!,
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
                        value.data?.phone ?? "",
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
                        value.data?.actualStopdate ?? "",
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
                        value.data?.timeRecord?.driver?.driverIn ?? '',
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
                        value.data?.timeRecord?.driver?.out ?? '',
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
              ItemsWidget(commodities: value.data?.mComodities ?? []),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Company Instruction',
                    style: getBoldStyle(color: ColorManager.darkgrey),
                  ),
                  Text(
                    value.data!.genInstructions ?? '',
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
                    value.data!.instructions ?? '',
                    style: getRegularStyle(
                        color: ColorManager.lightgrey, fontSize: 14),
                  ),
                ],
              )
            ],
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
