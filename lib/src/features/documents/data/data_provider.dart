import 'package:alvys3/src/features/documents/data/datasources/trip_docs_remote_data_source.dart';
import 'package:alvys3/src/features/documents/data/repositories/documents_repository.dart';
import 'package:alvys3/src/features/documents/data/repositories/trip_docs_repository_impl.dart';
import 'package:alvys3/src/features/documents/presentation/upload_documents_controller.dart';
//import 'package:alvys3/src/features/documents/presentation/upload_options.dart';
import 'package:alvys3/src/network/api_client.dart';
import 'package:alvys3/src/network/network_module.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tripDocsRemoteDataSourceImpl = Provider<TripDocsRemoteDataSourceImpl>(
  (ref) => TripDocsRemoteDataSourceImpl(ref.watch(apiClient)),
);

final tripDocsRepositoryImplProvider = Provider<TripDocsRepositoryImpl>(
  (ref) {
    final networkInfo = ref.watch(networkInfoProvider);
    final datasource = ref.watch(tripDocsRemoteDataSourceImpl);
    return TripDocsRepositoryImpl(datasource, networkInfo);
  },
);

final documentsRepositoryProvider =
    Provider<AppDocumentsRepository<UploadDocumentsController>>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  final fileProgress = ref.watch(fileUploadProvider.notifier);
  return AppDocumentsRepository(networkInfo, fileProgress);
});
