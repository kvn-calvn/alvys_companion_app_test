import 'buttons.dart';
import 'snack_bar.dart';
import '../constants/color.dart';
import '../utils/extensions.dart';
import '../utils/magic_strings.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../features/trips/domain/model/app_trip/stop.dart';

class StopCard extends ConsumerWidget {
  const StopCard({Key? key, required this.stop, required this.tripId, this.canCheckInOutStopId}) : super(key: key);

  final Stop stop;
  final String tripId;
  final String? canCheckInOutStopId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Material(
          elevation: 0,
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              context.goNamed(RouteName.stopDetails.name,
                  pathParameters: {ParamType.tripId.name: tripId, ParamType.stopId.name: stop.stopId!});
            },
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(15, 5, 15, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 8, 0),
                          child: Container(
                            decoration: BoxDecoration(
                                color:
                                    stop.stopType == 'Pickup' ? ColorManager.pickupColor : ColorManager.deliveryColor,
                                borderRadius: BorderRadius.circular(10)),
                            width: 8,
                            height: 77,
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stop.companyName!,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                stop.address?.street ?? "",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                '${stop.address?.city ?? ''} ${stop.address?.state ?? ''} ${stop.address?.zip ?? ''}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(DateFormat("MMM dd, yyyy @ hh:mm").formatNullDate(stop.stopDate),
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    // buttonPadding: const EdgeInsetsDirectional.only(end: 12),
                    // alignment: MainAxisAlignment.start,
                    children: [
                      ButtonStyle2(
                        onPressAction: canCheckInOutStopId == stop.stopId && stop.timeRecord?.driver?.timeIn == null
                            ? () {
                                debugPrint("");
                              }
                            : null,
                        title: stop.timeRecord?.driver?.timeIn == null ? "Check In" : "Checked In",
                        isLoading: false,
                      ),
                      const SizedBox(width: 5),
                      ButtonStyle2(
                        onPressAction: canCheckInOutStopId == stop.stopId &&
                                stop.timeRecord?.driver?.timeIn.isNotNull != null &&
                                stop.timeRecord?.driver?.timeOut == null
                            ? () {
                                SnackBarWrapper.snackBar(msg: "Checked In", context: context, isSuccess: true);
                              }
                            : null,
                        title: stop.timeRecord?.driver?.timeOut == null ? "Check Out" : 'Checked Out',
                        isLoading: false,
                      ),
                      const SizedBox(width: 5),
                      ButtonStyle2(
                        onPressAction: () => {debugPrint("")},
                        title: "E-Check",
                        isLoading: false,
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
