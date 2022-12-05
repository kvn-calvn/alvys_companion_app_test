import 'package:alvys3/src/features/trips/data/data_provider.dart';
import 'package:alvys3/src/features/trips/domain/trip_details/trip_details.dart';
import 'package:alvys3/src/network/api_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getTripDetailsProvider = FutureProvider.autoDispose
    .family<ApiResponse<TripDetails?>, String>((ref, tripId) async {
  final res = await ref.read(tripRepositoryImplProvider).getTripDetails(tripId);

  return res;
});
