import 'package:alvys3/src/features/trips/data/repositories/trip_repository_impl.dart';
import 'package:alvys3/src/features/trips/data/datasource/trips_remote_datasource.dart';
import 'package:alvys3/src/network/network_module.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final tripRemoteDataSource = Provider<TripsRemoteDataSourceImpl>(
    (ref) => TripsRemoteDataSourceImpl(ref.watch(apiClient)));

final tripRepositoryImplProvider = Provider<TripRepositoryImpl>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  final datasource = ref.watch(tripRemoteDataSource);
  return TripRepositoryImpl(datasource, networkInfo);
});
