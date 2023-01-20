import 'package:alvys3/src/features/documents/data/datasources/trip_docs_remote_data_source.dart';
import 'package:alvys3/src/features/documents/data/repositories/trip_docs_repository.dart';
import 'package:alvys3/src/features/documents/domain/app_documents/app_documents.dart';
import 'package:alvys3/src/network/api_response.dart';
import 'package:alvys3/src/network/error_handler.dart';
import 'package:alvys3/src/network/network_info.dart';

class TripDocsRepositoryImpl implements TripDocsRepository {
  final TripDocsRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  TripDocsRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<ApiResponse<List<AppDocuments>>> getTripDocs(String tripId) async {
    if (await _networkInfo.isConnected) {
      try {
        var response = await _remoteDataSource.getTripDocs(tripId);

        return ApiResponse(data: response);
      } catch (error) {
        return ApiResponse(
          success: false,
          error: ErrorHandler.handle(error).failure.message,
        );
      }
    } else {
      return ApiResponse(
        success: false,
        error: DataSource.NO_INTERNET_CONNECTION.getFailure().message,
      );
    }
  }
}
