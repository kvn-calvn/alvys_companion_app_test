import 'package:alvys3/src/features/echeck/domain/echeck_list/echeck_list.dart';
import 'package:alvys3/src/features/echeck/domain/echeck_query/echeck_query.dart';
import 'package:alvys3/src/network/api_response.dart';

abstract class EcheckRepository {
  Future<ApiResponse<EcheckList>> getEchecksByTripId(String tripId);
  Future<ApiResponse<EcheckQuery>> queryExpressNumber(
      String expressCheckNumber);
}
