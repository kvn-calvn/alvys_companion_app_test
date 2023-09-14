import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/custom_bottom_sheet.dart';
import '../../../../common_widgets/empty_view.dart';
import '../../../../common_widgets/large_nav_button.dart';
import '../../../../common_widgets/shimmers/documents_shimmer.dart';
import '../../../../utils/magic_strings.dart';
import '../../../documents/presentation/upload_options.dart';
import '../controller/trip_page_controller.dart';

class TripDocuments extends ConsumerWidget {
  final String tripId;
  const TripDocuments(this.tripId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(tripControllerProvider);
    var notifier = ref.read(tripControllerProvider.notifier);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCustomBottomSheet(
            context,
            UploadOptions(documentType: DocumentType.tripDocuments, tripId: tripId, mounted: context.mounted),
          );
        },
        child: const Icon(Icons.cloud_upload),
      ),
      body: state.isLoading
          ? const DocumentsShimmer()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: RefreshIndicator(
                onRefresh: () => notifier.refreshCurrentTrip(tripId),
                child: state.value!.getTrip(tripId).attachments.isEmpty
                    ? const EmptyView(title: 'No Load Documents', description: 'Uploaded documents will appear here.')
                    : ListView.builder(
                        itemCount: state.value!.getTrip(tripId).attachments.length,
                        itemBuilder: (context, index) {
                          var doc = state.value!.getTrip(tripId).attachments[index];
                          return LargeNavButton(
                              title: doc.documentType,
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
