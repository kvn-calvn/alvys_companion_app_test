import '../../../../common_widgets/empty_view.dart';
import '../../../../common_widgets/large_nav_button.dart';
import '../controller/trip_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TripDocuments extends ConsumerWidget {
  final String tripId;
  const TripDocuments(this.tripId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(tripControllerProvider);
    var notifier = ref.read(tripControllerProvider.notifier);
    return state.isLoading
        ? SpinKitSpinningCircle()
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
                        return LargeNavButton(title: doc.documentType, onPressed: () {});
                      },
                    ),
            ),
          );
  }
}
