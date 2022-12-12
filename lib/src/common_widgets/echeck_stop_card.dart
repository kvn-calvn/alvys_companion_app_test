import 'package:alvys3/src/constants/color.dart';
import 'package:flutter/material.dart';

class ECheckStopCard extends StatelessWidget {
  const ECheckStopCard({
    Key? key,
    required this.stopType,
    required this.stopName,
    required this.city,
    required this.state,
    required this.zip,
  }) : super(key: key);

  final String stopType;
  final String stopName;
  final String city;
  final String state;
  final String zip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: 2,
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 8, 0, 8),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: stopType == 'Pickup'
                            ? ColorManager.pickupColor
                            : ColorManager.deliveryColor,
                        borderRadius: BorderRadius.circular(10)),
                    width: 8,
                    height: 35,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stopName,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      "$city, $state $zip",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
