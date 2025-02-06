import 'package:alvys3/custom_icons/alvys_mobile_icons.dart';
import 'package:alvys3/src/utils/helpers.dart';

import '../../../../constants/color.dart';
import '../../../authentication/presentation/auth_provider_controller.dart';
import '../../../trailers/presentation/pages/search_truck_page.dart';
import '../../domain/app_trip/app_trip.dart';
import '../controller/trip_page_controller.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TripDetailsInfo extends ConsumerWidget {
  final AppTrip trip;
  const TripDetailsInfo(this.trip, {super.key});

  Widget _trailerWidget(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final canEditTrailer = authState.value?.canEditTrailer(trip.companyCode ?? '') ?? false;

    return Expanded(
      flex: 3,
      child: InkWell(
        onTap: !trip.canAssignTrailer || !canEditTrailer
            ? null
            : () async {
                await showSearchTruckSheet(
                  context: context,
                  dto: trip.assignTrailerDto,
                  onSelect: (trailer) {
                    ref.read(tripControllerProvider.notifier).updateTrailerNumber(
                          trip.assignTrailerDto.copyWith(
                            trailerNumber: trailer.trailerNumber,
                            trailerId: trailer.trailerId,
                          ),
                        );
                  },
                );
              },
        child: !trip.canAssignTrailer || !canEditTrailer
            ? Text(trip.trailerNum ?? "--",
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ))
            : RichText(
                textAlign: TextAlign.end,
                text: TextSpan(
                  children: [
                    if (!trip.trailerNum.isNullOrEmpty) ...[
                      WidgetSpan(
                        child: Icon(
                          AlvysMobileIcons.edit,
                          size: 16,
                          color: ColorManager.blue500(Theme.of(context).brightness),
                        ),
                      ),
                      WidgetSpan(
                        child: SizedBox(width: 5),
                      ),
                    ],
                    TextSpan(
                      text: trip.trailerNum.isNullOrEmpty ? 'Add' : '${trip.trailerNum}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorManager.blue500(
                              Theme.of(context).brightness,
                            ),
                          ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var authState = ref.watch(authProvider);
    return Column(
      children: [
        if (trip.driverPayable(authState.value!.tryGetUserTenant(trip.companyCode!)?.assetId) !=
                null &&
            authState.value!.shouldShowPayableAmount(trip.companyCode!))
          Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: "You're getting paid ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: ColorManager.caption(
                                Theme.of(context).brightness,
                              ),
                            ),
                        children: [
                          TextSpan(
                            text: Helpers.fixedAmountDecimals(trip.driverPayable(authState.value!
                                    .tryGetUserTenant(trip.companyCode!)!
                                    .assetId!) ??
                                0),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: ColorManager.valid,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        SizedBox(height: 15),
        Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Wrap(
              runSpacing: 14,
              children: [
                DetailInfoItem(
                  title: 'Distance',
                  value: trip.totalMiles != null
                      ? '${Helpers.fixedDecimals(trip.totalMiles!)} mi'
                      : null,
                ),
                DetailInfoItem(
                  title: 'Truck',
                  value: '${trip.equipment} ${trip.equipmentLength}'.trim().isEmpty
                      ? null
                      : '${trip.equipment} ${trip.equipmentLength}',
                ),
                DetailInfoItem(
                  title: 'Trailer',
                  trailing: _trailerWidget(context, ref),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Wrap(
              runSpacing: 14,
              children: [
                DetailInfoItem(
                  title: 'Load Weight',
                  value: trip.totalWeight != null
                      ? '${Helpers.fixedDecimals(trip.totalWeight!)} ${trip.loadWeightUnit}'
                      : null,
                ),
                DetailInfoItem(
                  title: 'Volume',
                  value: trip.loadVolume != null
                      ? '${Helpers.fixedDecimals(trip.loadVolume!)} ${trip.loadVolumeUnit}'
                      : null,
                ),
                DetailInfoItem(
                  title: 'Setpoint Temp',
                  value: trip.setPointTemperature != null
                      ? '${Helpers.fixedDecimals(trip.setPointTemperature!)}° F'
                      : null,
                ),
                DetailInfoItem(
                  title: 'Probe Temp',
                  value: trip.probeTemperature != null
                      ? '${Helpers.fixedDecimals(trip.probeTemperature!)}° F'
                      : null,
                ),
                DetailInfoItem(
                  title: 'Required Temp',
                  value: trip.temperature != null
                      ? '${Helpers.fixedDecimals(trip.temperature!)}° F'
                      : null,
                ),
                DetailInfoItem(
                  title: 'Trailer Status',
                  value: trip.trailerStatus,
                ),
                DetailInfoItem(
                  title: 'Fuel %',
                  value: trip.fuelPercentage != null
                      ? '${Helpers.fixedDecimals(trip.fuelPercentage!)}%'
                      : null,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class DetailInfoItem extends StatelessWidget {
  final String title;
  final String? value;
  final Widget? trailing;

  const DetailInfoItem({
    super.key,
    required this.title,
    this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: ColorManager.caption(Theme.of(context).brightness),
              ),
        ),
        Spacer(),
        if (trailing == null)
          Text(
            value ?? '--',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
          )
        else
          trailing!,
      ],
    );
  }
}
