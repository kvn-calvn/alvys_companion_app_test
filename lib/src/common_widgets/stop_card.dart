import 'package:alvys3/src/common_widgets/buttons.dart';
import 'package:alvys3/src/common_widgets/snack_bar.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/utils/extensions.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../features/trips/domain/model/app_trip/stop.dart';

class StopCard extends ConsumerWidget {
  const StopCard({Key? key, required this.stop, required this.tripId, this.canCheckInOut = false}) : super(key: key);

  final Stop stop;
  final String tripId;
  final bool canCheckInOut;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Material(
          elevation: 0,
          color: stop.stopType == 'Pickup'
              ? ColorManager.pickupStopCardBg(Theme.of(context).brightness)
              : ColorManager.deliveryStopCardBg(Theme.of(context).brightness),
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
                      children: [
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
                                stop.street!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                '${stop.city} ${stop.state} ${stop.zip}',
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
                        onPressAction: (canCheckInOut && stop.timeRecord?.driver?.timeIn == null)
                            ? () {
                                debugPrint("");
                              }
                            : null,
                        title: "Checked In",
                        isLoading: false,
                      ),
                      const SizedBox(width: 5),
                      ButtonStyle2(
                        onPressAction: (canCheckInOut &&
                                stop.timeRecord?.driver?.timeIn != null &&
                                stop.timeRecord?.driver?.timeOut == null)
                            ? () {
                                SnackBarWrapper.snackBar(msg: "Checked In", context: context, isSuccess: true);
                              }
                            : null,
                        title: "Check Out",
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
