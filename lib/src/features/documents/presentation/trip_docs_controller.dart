import 'package:alvys3/src/features/documents/data/data_provider.dart';
import 'package:alvys3/src/features/documents/data/repositories/trip_docs_repository_impl.dart';
import 'package:alvys3/src/features/documents/domain/trip_documents/trip_documents.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TripsDocsPageController
    extends StateNotifier<AsyncValue<TripDocuments?>> {
  TripsDocsPageController(this._tripDocsRepositoryImpl)
      : super(const AsyncValue.data(null));
  final TripDocsRepositoryImpl _tripDocsRepositoryImpl;

  void getTripDocsList(String tripId) async {
    state = const AsyncValue.loading();
    final result = await _tripDocsRepositoryImpl.getTripDocs(tripId);
    if (result.success) {
      state = AsyncValue.data(result.data!);
    } else {
      state = AsyncValue.error(result.error!);
    }
  }
}

final tripDocsPageControllerProvider = StateNotifierProvider.autoDispose<
    TripsDocsPageController, AsyncValue<TripDocuments?>>((ref) {
  return TripsDocsPageController(ref.watch(tripDocsRepositoryImplProvider));
});
