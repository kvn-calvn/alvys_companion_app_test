import '../../../../constants/color.dart';
import '../../../authentication/presentation/auth_provider_controller.dart';
import '../../../trailers/presentation/pages/search_truck_page.dart';
import '../../domain/app_trip/app_trip.dart';
import '../controller/trip_page_controller.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../custom_icons/alvys_mobile_icons.dart';

class TripDetailsInfo extends ConsumerWidget {
  final AppTrip trip;
  const TripDetailsInfo(this.trip, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var equipment = "${trip.equipment} ${trip.equipmentLength}".trim();
    final authState = ref.watch(authProvider);
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Wrap(
          runSpacing: 14,
          children: [
            DetailsInfoCard(
              icon: AlvysMobileIcons.trip,
              title: trip.totalMiles?.toString() == null
                  ? null
                  : '${NumberFormat.decimalPatternDigits(decimalDigits: 1).format(trip.totalMiles)} mi',
            ),
            DetailsInfoCard(
              icon: AlvysMobileIcons.truckBox,
              title: trip.equipment.isNullOrEmpty ? null : equipment,
            ),
            DetailsInfoCard(
              icon: AlvysMobileIcons.trailer,
              title: 'Trailer ${trip.trailerNum.isNullOrEmpty ? '-' : trip.trailerNum}',
              actionTitle: (trip.canAssignTrailer && authState.value!.canEditTrailer(trip.companyCode!))
                  ? trip.trailerNum.isNullOrEmpty
                      ? 'Add'
                      : 'Change'
                  : null,
              onTap: () async {
                await showSearchTruckSheet(
                  context: context,
                  dto: trip.assignTrailerDto,
                  onSelect: (trailer) {
                    ref.read(tripControllerProvider.notifier).updateTrailerNumber(trip.assignTrailerDto
                        .copyWith(trailerNumber: trailer.trailerNumber, trailerId: trailer.trailerId));
                  },
                );
              },
              dim: trip.trailerNum.isNullOrEmpty,
            ),
            DetailsInfoCard(
              icon: AlvysMobileIcons.temperature,
              title: trip.temperature == null
                  ? null
                  : '${trip.temperature!.toStringAsFixed(1)} °f ${(trip.continuous ?? false) ? '(cont.)' : ''}',
            ),
            DetailsInfoCard(
              icon: AlvysMobileIcons.weight,
              title: trip.totalWeight == null
                  ? null
                  : '${NumberFormat.decimalPatternDigits(decimalDigits: 1).format(trip.totalWeight)} lbs',
            ),
            DetailsInfoCard(
              icon: AlvysMobileIcons.invoice,
              title: trip.driverPayable(authState.value!.tryGetUserTenant(trip.companyCode!)?.assetId) != null &&
                      authState.value!.shouldShowPayableAmount(trip.companyCode!)
                  ? 'Driver Payable ${NumberFormat.simpleCurrency().format(trip.driverPayable(authState.value!.tryGetUserTenant(trip.companyCode!)!.assetId!))}'
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsInfoCard extends StatelessWidget {
  final IconData icon;
  final String? title;
  final bool dim;
  final void Function()? onTap;
  final String? actionTitle;
  const DetailsInfoCard({super.key, this.dim = false, required this.icon, this.title, this.onTap, this.actionTitle});

  @override
  Widget build(BuildContext context) {
    return title == null
        ? SizedBox.shrink()
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 22),
                  SizedBox(width: 10),
                  Text(title!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.normal,
                          color: dim ? Colors.grey : Theme.of(context).textTheme.bodyMedium?.color)),
                ],
              ),
              InkWell(
                onTap: onTap,
                child: actionTitle == null
                    ? SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                        child: Text(
                          actionTitle!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: ColorManager.primary(Theme.of(context).brightness)),
                        ),
                      ),
              )
            ],
          );
  }
}
