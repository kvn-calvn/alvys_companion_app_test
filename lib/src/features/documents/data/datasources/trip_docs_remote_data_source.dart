import 'package:alvys3/src/constants/api_routes.dart';
import 'package:alvys3/src/features/documents/domain/app_documents/app_documents.dart';
import 'package:alvys3/src/network/api_client.dart';
import '../../../../utils/extensions.dart';

abstract class TripDocsRemoteDataSource {
  Future<List<AppDocuments>> getTripDocs(String tripId);
}

class TripDocsRemoteDataSourceImpl implements TripDocsRemoteDataSource {
  final ApiClient _apiClient;
  TripDocsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<AppDocuments>> getTripDocs(String tripId) async {
    var res = await _apiClient.getData(ApiRoutes.tripDocs(tripId));

    return (res.data['Data'] as List<dynamic>?).toListNotNull().map((x) => AppDocuments.fromJson(x)).toList();
  }
}
