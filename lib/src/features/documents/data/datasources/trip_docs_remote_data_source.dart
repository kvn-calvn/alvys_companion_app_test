import 'package:alvys3/src/constants/api_routes.dart';
import 'package:alvys3/src/features/documents/domain/trip_documents/trip_documents.dart';
import 'package:alvys3/src/network/api_client.dart';
import '../../../../utils/extensions.dart';

abstract class TripDocsRemoteDataSource {
  Future<List<TripDocuments>> getTripDocs(String tripId);
}

class TripDocsRemoteDataSourceImpl implements TripDocsRemoteDataSource {
  final ApiClient _apiClient;
  TripDocsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<TripDocuments>> getTripDocs(String tripId) async {
    var res = await _apiClient.dio.get(ApiRoutes.tripdocs + tripId);

    return (res.data['Data'] as List<dynamic>?)
        .toListNotNull()
        .map((x) => TripDocuments.fromJson(x))
        .toList();
  }
}
