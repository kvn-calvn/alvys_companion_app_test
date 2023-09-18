import 'package:flutter/services.dart';

import '../features/tutorial/tutorial_controller.dart';
import '../utils/dummy_data.dart';

import '../features/authentication/presentation/auth_provider_controller.dart';
import '../features/echeck/presentation/pages/generate_echeck.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../constants/color.dart';
import '../features/trips/domain/app_trip/stop.dart';
import '../features/trips/presentation/controller/trip_page_controller.dart';
import '../utils/magic_strings.dart';
import 'buttons.dart';

class StopCard extends ConsumerWidget {
  const StopCard({
    Key? key,
    required this.stop,
    required this.tripId,
    this.canCheckInOutStopId,
    required this.index,
    required this.tabIndex,
  }) : super(key: key);
  final int index;
  final Stop stop;
  final String tripId;
  final int tabIndex;
  final String? canCheckInOutStopId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tripNotifier = ref.read(tripControllerProvider.notifier);
    var tripState = ref.read(tripControllerProvider);
    var authState = ref.watch(authProvider);
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Material(
          key: tripId == testTrip.id! && index == 0
              ? ref.read(tutorialProvider).stopCard
              : null,
          elevation: 0,
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              context.goNamed(RouteName.stopDetails.name, pathParameters: {
                ParamType.tripId.name: tripId,
                ParamType.stopId.name: stop.stopId!
              }, queryParameters: {
                ParamType.tabIndex.name: tabIndex.toString(),
              });
            },
            child: Container(
              padding: const EdgeInsetsDirectional.fromSTEB(15, 5, 5, 5),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Color strip
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 6, 8, 0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: stop.stopType == 'Pickup'
                                  ? ColorManager.pickupColor
                                  : ColorManager.deliveryColor,
                              borderRadius: BorderRadius.circular(10)),
                          width: 8,
                          height: 77,
                        ),
                      ),
                      //Stop name and adress
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth * 0.8),
                        child: //Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //crossAxisAlignment: CrossAxisAlignment.end,
                            //children: [
                            Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stop.companyName!,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            SelectableText.rich(
                              TextSpan(
                                text: stop.address?.street ?? "",
                                style: Theme.of(context).textTheme.bodyMedium,
                                children: [
                                  if (stop.address?.apartmentNumber
                                          .isNotNullOrEmpty ??
                                      false)
                                    TextSpan(
                                      text:
                                          '\n${stop.address?.apartmentNumber ?? ''}',
                                    ),
                                  TextSpan(
                                    text:
                                        '\n${stop.address?.city ?? ''}, ${stop.address?.state ?? ''} ${stop.address?.zip ?? ''}',
                                  )
                                ],
                              ),
                            ),
                            Text(
                                DateFormat("MMM dd, yyyy @ hh:mm")
                                    .formatNullDate(stop.stopDate),
                                style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                        //],
                        //),
                      ),
                      const Spacer(),
                      //Copy button
                      Opacity(
                        opacity: 0.5,
                        child: IconButton(
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: stop.stopAddress));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Address Coppied')),
                            );
                          },
                          icon: const Icon(Icons.copy),
                        ),
                      )
                    ],
                  ),

                  //Button row
                  const SizedBox(height: 6),
                  Row(
                    // buttonPadding: const EdgeInsetsDirectional.only(end: 12),
                    // alignment: MainAxisAlignment.start,
                    children: [
                      tripState.value!.checkIn &&
                              tripState.value!.loadingStopId == stop.stopId!
                          ? const ButtonLoading()
                          : ButtonStyle2(
                              onPressAction: canCheckInOutStopId ==
                                          stop.stopId &&
                                      stop.timeRecord?.driver?.timeIn == null
                                  ? () async => await tripNotifier.checkIn(
                                      tripId, stop.stopId!)
                                  : null,
                              title: stop.timeRecord?.driver?.timeIn == null
                                  ? "Check In"
                                  : "Checked In",
                              isLoading: false,
                            ),
                      const SizedBox(width: 5),
                      !tripState.value!.checkIn &&
                              tripState.value!.loadingStopId == stop.stopId!
                          ? const ButtonLoading()
                          : ButtonStyle2(
                              onPressAction: canCheckInOutStopId ==
                                          stop.stopId &&
                                      stop.timeRecord?.driver?.timeIn != null &&
                                      stop.timeRecord?.driver?.timeOut == null
                                  ? () async => await tripNotifier.checkOut(
                                      tripId, stop.stopId!)
                                  : null,
                              title: stop.timeRecord?.driver?.timeOut == null
                                  ? "Check Out"
                                  : 'Checked Out',
                              isLoading: false,
                            ),
                      const SizedBox(width: 5),
                      ButtonStyle2(
                        onPressAction: authState.value!.shouldShowEcheckButton(
                                tripState.value!.getTrip(tripId).companyCode!)
                            ? () => showGenerateEcheckDialog(
                                context, tripId, stop.stopId)
                            : null,
                        title: "E-Check",
                        isLoading: false,
                      ),
                      const SizedBox(width: 5),
                    ],
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

class ButtonLoading extends StatelessWidget {
  final double height;
  const ButtonLoading({super.key, this.height = 24});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: null,
        child: SizedBox(
            width: height,
            height: height,
            child: const CircularProgressIndicator.adaptive()));
  }
}
