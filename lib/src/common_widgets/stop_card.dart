import 'package:alvys3/src/common_widgets/buttons.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/features/trips/presentation/trip/trip_page_controller.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/trips/domain/app_trip/stop.dart';

class StopCard extends ConsumerWidget {
  const StopCard({Key? key, required this.stop, required this.tripId})
      : super(key: key);

  final Stop stop;
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: 2,
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            ref
                .watch(tripPageControllerProvider.notifier)
                .setCurrentStop(stop.stopId!);
            context.pushNamed(RouteName.stopDetails.name);
          },
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(15, 5, 15, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                  child: Row(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
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
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.80,
                            child: Text(
                              stop.companyName!,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                          Text(
                            stop.street!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '${stop.city} ${stop.state} ${stop.zip}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'Jan 28, 2022 @ 15:00',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ButtonBar(
                  buttonPadding: const EdgeInsetsDirectional.only(end: 12),
                  alignment: MainAxisAlignment.start,
                  children: [
                    ButtonStyle2(
                        onPressAction: () => {debugPrint("")},
                        title: "Checked In",
                        isLoading: false,
                        isDisable: true),
                    ButtonStyle2(
                        onPressAction: () => {debugPrint("")},
                        title: "Check Out",
                        isLoading: false,
                        isDisable: false),
                    ButtonStyle2(
                        onPressAction: () => {debugPrint("")},
                        title: "E-Check",
                        isLoading: false,
                        isDisable: false),
                  ],
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
