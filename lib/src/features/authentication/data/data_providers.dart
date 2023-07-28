import 'package:alvys3/src/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:alvys3/src/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:alvys3/src/network/api_client.dart';
import 'package:alvys3/src/network/network_module.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/auth_provider_controller.dart';
import 'auth_repository.dart';

final authRemoteDataSourceImpl =
    Provider<AuthRemoteDataSourceImpl>((ref) => AuthRemoteDataSourceImpl(ref.watch(apiClient)));

final authRepositoryImplProvider = Provider<AuthRepositoryImpl>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  final datasource = ref.watch(authRemoteDataSourceImpl);
  return AuthRepositoryImpl(datasource, networkInfo);
});

final authRepoProvider = Provider<AvysAuthRepository<AuthProviderNotifier>>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  final apiClient = ref.read(apiClientProvider);
  return AvysAuthRepository(networkInfo, apiClient);
});
