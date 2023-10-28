import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/color.dart';
import '../../trips/domain/app_trip/stop.dart';

class FullMapStopCard extends ConsumerWidget {
  final Stop stop;
  const FullMapStopCard(this.stop, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            color: Theme.of(context).cardColor,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 8, 0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: stop.stopType == 'Pickup' ? ColorManager.pickupColor : ColorManager.deliveryColor,
                        borderRadius: BorderRadius.circular(10)),
                    width: 8,
                    // height: 77,
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
                    ],
                  ),
                ),
              ],
            )),
      );
    });
  }
}
