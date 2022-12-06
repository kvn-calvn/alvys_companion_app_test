import 'package:alvys3/src/common_widgets/buttons.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
import 'package:alvys3/src/features/trips/domain/trip_details/mini_stop.dart';
import 'package:alvys3/src/features/trips/presentation/trip/trip_page_controller.dart';
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
    return GestureDetector(
      onTap: () {
        ref
            .watch(tripPageControllerProvider.notifier)
            .setCurrentStop(stop.stopId!);
        context.pushNamed('stopDetails');
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                blurRadius: 2,
                color: Color(0x3416202A),
                offset: Offset(0, 1),
              )
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(15, 5, 15, 5),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 8, 0),
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
                                  style: getBoldStyle(
                                      color: ColorManager.lightgrey,
                                      fontSize: 16),
                                ),
                              ),
                              Text(
                                stop.street!,
                                style: getMediumStyle(
                                    color: ColorManager.lightgrey,
                                    fontSize: 14),
                              ),
                              Text(
                                '${stop.city} ${stop.state} ${stop.zip}',
                                style: getMediumStyle(
                                    color: ColorManager.lightgrey,
                                    fontSize: 14),
                              ),
                              Text(
                                'Jan 28, 2022 @ 15:00',
                                style: getMediumStyle(
                                    color: ColorManager.lightgrey,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 5, 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ButtonStyle2(
                              onPressAction: () => {debugPrint("")},
                              title: "Checked In",
                              isLoading: false,
                              isDisable: true),
                          const SizedBox(
                            width: 5,
                          ),
                          ButtonStyle2(
                              onPressAction: () => {debugPrint("")},
                              title: "Check Out",
                              isLoading: false,
                              isDisable: false),
                          const SizedBox(
                            width: 10,
                          ),
                          ButtonStyle2(
                              onPressAction: () => {debugPrint("")},
                              title: "E-Check",
                              isLoading: false,
                              isDisable: false),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
