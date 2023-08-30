import '../../../../constants/api_routes.dart';
import '../../../../network/api_client.dart';
import '../../domain/echeck_list/echeck_list.dart';
import '../../domain/echeck_query/echeck_query.dart';

abstract class EcheckRemoteDataSource {
  Future<EcheckList> getEchecksByTripId(String tripId);
  Future<EcheckQuery> queryExpressNumber(String expressCheckNumber);
}

class EcheckRemoteDataSourceImpl implements EcheckRemoteDataSource {
  final ApiClient _apiClient;
  EcheckRemoteDataSourceImpl(this._apiClient);

  @override
  Future<EcheckList> getEchecksByTripId(String tripId) async {
    var res = await _apiClient.getData(ApiRoutes.getEchecksByTrip(tripId));
    return EcheckList.fromJson(res.data);
  }

  @override
  Future<EcheckQuery> queryExpressNumber(String expressCheckNumber) async {
    throw UnimplementedError();
  }
}
