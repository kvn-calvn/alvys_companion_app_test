import 'package:alvys3/src/constants/api_routes.dart';
import 'package:alvys3/src/features/echeck/domain/echeck_list/echeck_list.dart';
import 'package:alvys3/src/features/echeck/domain/echeck_query/echeck_query.dart';
import 'package:alvys3/src/network/api_client.dart';

abstract class EcheckRemoteDataSource {
  Future<EcheckList> getEchecksByTripId(String tripId);
  Future<EcheckQuery> queryExpressNumber(String expressCheckNumber);
}

class EcheckRemoteDataSourceImpl implements EcheckRemoteDataSource {
  final ApiClient _apiClient;
  EcheckRemoteDataSourceImpl(this._apiClient);

  @override
  Future<EcheckList> getEchecksByTripId(String tripId) async {
    var res = await _apiClient.dio.get(ApiRoutes.getEchecksByTrip + tripId);
    return EcheckList.fromJson(res.data);
  }

  @override
  Future<EcheckQuery> queryExpressNumber(String expressCheckNumber) async {
    var res = await _apiClient.dio
        .get(ApiRoutes.queryExpressNumber + expressCheckNumber);
    return EcheckQuery.fromJson(res.data);
  }
}
