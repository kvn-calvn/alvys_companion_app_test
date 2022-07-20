import 'package:alvys3/src/features/echeck/data/datasources/echeck_remote_data_source.dart';
import 'package:alvys3/src/network/network_module.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'repositories/echeck_repository_impl.dart';

final echeckRemoteDataSourceImpl = Provider<EcheckRemoteDataSourceImpl>(
    (ref) => EcheckRemoteDataSourceImpl(ref.watch(apiClient)));

final echeckRepositoryImplProvider = Provider<EcheckRepositoryImpl>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  final datasource = ref.watch(echeckRemoteDataSourceImpl);
  return EcheckRepositoryImpl(datasource, networkInfo);
});
