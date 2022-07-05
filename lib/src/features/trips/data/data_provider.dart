import 'package:alvys3/src/features/trips/data/trip_repository_impl.dart';
import 'package:alvys3/src/features/trips/data/trips_remote_data_source.dart';
import 'package:alvys3/src/network/network_module.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tripRemoteDataSourceImpl = Provider<TripsRemoteDataSourceImpl>(
    (ref) => TripsRemoteDataSourceImpl(ref.watch(apiClient)));

final tripRepositoryImplProvider = Provider<TripRepositoryImpl>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  final datasource = ref.watch(tripRemoteDataSourceImpl);
  return TripRepositoryImpl(datasource, networkInfo);
});
