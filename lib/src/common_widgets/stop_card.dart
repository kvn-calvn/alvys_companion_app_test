import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/color.dart';
import '../features/trips/domain/app_trip/stop.dart';
import '../features/trips/presentation/controller/trip_page_controller.dart';
import '../features/trips/presentation/pages/stop_details_page.dart';
import '../features/tutorial/tutorial_controller.dart';
import '../network/http_client.dart';
import '../network/posthog/posthog_provider.dart';
import '../utils/dummy_data.dart';
import '../utils/magic_strings.dart';
import 'buttons.dart';

class StopCard extends ConsumerWidget {
  const StopCard({
    super.key,
    required this.stop,
    required this.tripId,
    this.canCheckInOutStopId,
    required this.index,
    required this.tabIndex,
  });
  final int index;
  final Stop stop;
  final String tripId;
  final int tabIndex;
  final String? canCheckInOutStopId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tripNotifier = ref.read(tripControllerProvider.notifier);
    var tripState = ref.read(tripControllerProvider);
    final postHogService = ref.read(postHogProvider);

    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Material(
          key: tripId == testTrip.id! && index == 0 ? ref.read(tutorialProvider).stopCard : null,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Color strip
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 8, 0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: stop.stopType == 'Pickup' ? ColorManager.pickupColor : ColorManager.deliveryColor,
                              borderRadius: BorderRadius.circular(10)),
                          width: 8,
                          height: 77,
                        ),
                      ),
                      //Stop name and adress
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.75),
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
                                  if (stop.address?.apartmentNumber.isNotNullOrEmpty ?? false)
                                    TextSpan(
                                      text: '\n${stop.address?.apartmentNumber ?? ''}',
                                    ),
                                  TextSpan(
                                    text:
                                        '\n${stop.address?.city ?? ''}, ${stop.address?.state ?? ''} ${stop.address?.zip ?? ''}',
                                  )
                                ],
                              ),
                            ),
                            StopDateDetails(args: stop.formattedStopDate, style: Theme.of(context).textTheme.bodySmall),
                            const SizedBox(height: 6),
                            StopLoadingTypeWidget(stop),
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
                          onPressed: () async {
                            Clipboard.setData(ClipboardData(text: stop.address?.formattedAddress ?? ""));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Address Coppied')),
                            );
                            postHogService
                                .postHogTrackEvent("user_copied_stop_address", {
                              "address": stop.address?.formattedAddress ?? "",
                              "trip_id": tripId,
                              "stop_id": stop.stopId ?? "",
                            });
                            ref.read(httpClientProvider).telemetryClient.trackEvent(
                                name: "copied_stop_address",
                                additionalProperties: {"address": stop.address?.formattedAddress ?? ""});

                            await FirebaseAnalytics.instance.logEvent(
                                name: "copied_stop_address",
                                parameters: {"address": stop.address?.formattedAddress ?? ""});
                          },
                          icon: const Icon(Icons.copy),
                        ),
                      )
                    ],
                  ),

                  //Button row
                  const SizedBox(height: 6),
                  Wrap(
                    runAlignment: WrapAlignment.spaceBetween,
                    runSpacing: 5,
                    spacing: 5,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      tripState.value!.checkInLoading(stop)
                          ? const ButtonLoading()
                          : ButtonStyle2(
                              onPressAction: stop.canCheckIn(canCheckInOutStopId)
                                  ? () async => await tripNotifier.checkIn(tripId, stop.stopId!)
                                  : null,
                              title: stop.notCheckedIn ? "Check In" : "Checked In",
                              isLoading: false,
                            ),
                      // const SizedBox(width: 5),
                      tripState.value!.checkOutLoading(stop)
                          ? const ButtonLoading()
                          : ButtonStyle2(
                              onPressAction: stop.canCheckOut(canCheckInOutStopId)
                                  ? () async => await tripNotifier.checkOut(tripId, stop.stopId!)
                                  : null,
                              title: stop.notCheckedOut ? "Check Out" : 'Checked Out',
                              isLoading: false,
                            ),
                      // const SizedBox(width: 5),
                      ButtonStyle2(
                        onPressAction: ref.watch(tripControllerProvider.notifier).shouldShowEcheckButton(tripId)
                            ? () => ref
                                .read(tripControllerProvider.notifier)
                                .generateEcheckDialog(context, tripId, stop.stopId!)
                            : null,
                        title: "E-Check",
                        isLoading: false,
                      ),
                      // const SizedBox(width: 5),
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
        child: SizedBox(width: height, height: height, child: const CircularProgressIndicator.adaptive()));
  }
}

class StopLoadingTypeWidget extends StatelessWidget {
  final Stop stop;
  const StopLoadingTypeWidget(this.stop, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorManager.stopLoadingTypeColor,
      borderRadius: BorderRadius.circular(5),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 6.0),
        child: Text(
          stop.loadingType!,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
