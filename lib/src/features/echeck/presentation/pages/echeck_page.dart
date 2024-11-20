import 'package:firebase_analytics/firebase_analytics.dart';

import '../../../../common_widgets/fab_animator.dart';
import '../../../../common_widgets/shimmers/echecks_shimmer.dart';
import '../../../tutorial/tutorial_controller.dart';
import '../../../../utils/dummy_data.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';

import '../controller/echeck_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common_widgets/echeck_card.dart';
import '../../../../common_widgets/empty_view.dart';
import '../../../../constants/color.dart';
import '../../../trips/presentation/controller/trip_page_controller.dart';
import 'generate_echeck.dart';

class EcheckPage extends ConsumerStatefulWidget {
  final String tripId;
  const EcheckPage(this.tripId, {super.key});

  @override
  ConsumerState<EcheckPage> createState() => _EcheckPageState();
}

class _EcheckPageState extends ConsumerState<EcheckPage> {
  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.logScreenView(screenName: "echecks_page");
  }

  EcheckPageController get notifier => ref.read(echeckPageControllerProvider.call(null).notifier);
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(tripControllerProvider);
    if (state.isLoading) return const EchecksShimmer();

    var trip = state.value!.tryGetTrip(widget.tripId);
    if (trip == null) {
      return const EmptyView(title: 'Trip Not found', description: 'Return to the previous page');
    }
    return Stack(
      children: [
        if (trip.id == testTrip.id!)
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              padding: const EdgeInsets.all(28),
              key: ref.read(tutorialProvider).echeckButton,
            ),
          ),
        Scaffold(
          floatingActionButtonAnimator: AlvysFloatingActionButtonAnimator(),
          floatingActionButton:
              ref.watch(tripControllerProvider.notifier).shouldShowEcheckButton(trip.id) || trip.id == testTrip.id!
                  ? FloatingActionButton(
                      onPressed: () {
                        showGenerateEcheckDialog(context, widget.tripId);
                      },
                      backgroundColor: ColorManager.primary(Theme.of(context).brightness),
                      child: const Icon(Icons.attach_money, color: Colors.white),
                    )
                  : null,
          body: RefreshIndicator(
            onRefresh: () async {
              await ref.read(tripControllerProvider.notifier).refreshCurrentTrip(widget.tripId);
            },
            child: trip.sortedEchecks.isNullOrEmpty
                ? const EmptyView(title: 'No E-Checks', description: 'Generated E-Checks will appear here.')
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: trip.sortedEchecks.length,
                    itemBuilder: (context, index) => EcheckCard(
                      index: index,
                      eCheck: trip.sortedEchecks[index],
                      companyCode: trip.companyCode!,
                      tripNumber: trip.tripNumber!,
                      cancelECheck: (echeckNumber) async =>
                          await notifier.cancelEcheck(context, widget.tripId, echeckNumber),
                      tripId: widget.tripId,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
