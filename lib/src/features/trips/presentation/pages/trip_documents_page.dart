import '../../../../utils/tablet_utils.dart';

import '../../../../utils/dummy_data.dart';
import '../../../authentication/presentation/auth_provider_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/custom_bottom_sheet.dart';
import '../../../../common_widgets/empty_view.dart';
import '../../../../common_widgets/large_nav_button.dart';
import '../../../../common_widgets/shimmers/documents_shimmer.dart';
import '../../../../utils/magic_strings.dart';
import '../../../documents/presentation/upload_options.dart';
import '../../../tutorial/tutorial_controller.dart';
import '../controller/trip_page_controller.dart';

class TripDocuments extends ConsumerWidget {
  final String tripId;
  const TripDocuments(this.tripId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(tripControllerProvider);
    var notifier = ref.read(tripControllerProvider.notifier);
    var authState = ref.watch(authProvider);
    var trip = state.value!.tryGetTrip(tripId);
    if (state.isLoading) return const DocumentsShimmer();

    if (trip == null) {
      return const EmptyView(title: 'Trip Not found', description: 'Return to the previous page');
    }
    var attachments = trip.getAttachments(authState.value!.shouldShowCustomerRateConfirmations(trip.companyCode!),
        authState.value!.shouldShowCarrierConfirmations(trip.companyCode!));
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        key: ref.read(tutorialProvider).documentButton,
        onPressed: () {
          showCustomBottomSheet(
            context,
            UploadOptions(
                documentType: DisplayDocumentType.tripDocuments,
                tripId: tripId,
                tabIndex: TabletUtils.instance.detailsController.index,
                mounted: context.mounted),
          );
        },
        child: const Icon(Icons.cloud_upload),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: RefreshIndicator(
          onRefresh: () => notifier.refreshCurrentTrip(tripId),
          child: attachments.isEmpty
              ? const EmptyView(title: 'No Load Documents', description: 'Uploaded documents will appear here.')
              : ListView.builder(
                  itemCount: attachments.length,
                  padding: const EdgeInsets.only(top: 16.0),
                  itemBuilder: (context, index) {
                    var doc = state.value!.getTrip(tripId).attachments[index];
                    return LargeNavButton(
                        title: doc.documentType,
                        key: index == 0 && tripId == testTrip.id! ? ref.read(tutorialProvider).documentCard : null,
                        onPressed: () {
                          context.pushNamed(RouteName.tripDocumentView.name,
                              extra: doc, pathParameters: {ParamType.tripId.name: tripId});
                        });
                  },
                ),
        ),
      ),
    );
  }
}
