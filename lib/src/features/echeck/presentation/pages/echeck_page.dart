import 'package:alvys3/src/features/authentication/presentation/auth_provider_controller.dart';

import '../controller/echeck_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../common_widgets/echeck_card.dart';
import '../../../../common_widgets/empty_view.dart';
import '../../../../constants/color.dart';
import '../../../../utils/extensions.dart';
import '../../../trips/presentation/controller/trip_page_controller.dart';
import 'generate_echeck.dart';

class EcheckPage extends ConsumerStatefulWidget {
  final String tripId;
  const EcheckPage(this.tripId, {Key? key}) : super(key: key);

  @override
  ConsumerState<EcheckPage> createState() => _EcheckPageState();
}

class _EcheckPageState extends ConsumerState<EcheckPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authState = ref.watch(authProvider);
    var notifier = ref.read(echeckPageControllerProvider.notifier);
    var state = ref.watch(tripControllerProvider);
    var trip = ref.watch(tripControllerProvider).value!.tryGetTrip(widget.tripId);
    if (trip == null) return const EmptyView(title: 'Trip Not found', description: 'Return to the previous page');
    return state.isLoading
        ? SpinKitFoldingCube()
        : Scaffold(
            floatingActionButton: authState.value!.shouldShowEcheckButton(trip.companyCode!)
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
              child: trip.eChecks.isNullOrEmpty
                  ? const EmptyView(title: 'No E-Checks', description: 'Generated E-Checks will appear here.')
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: trip.eChecks!.length,
                      itemBuilder: (context, index) => EcheckCard(
                        eCheck: trip.eChecks![index],
                        companyCode: trip.companyCode!,
                        cancelECheck: (echeckNumber) async => await notifier.cancelEcheck(widget.tripId, echeckNumber),
                        tripId: widget.tripId,
                      ),
                    ),
            ),
          );
  }
}
