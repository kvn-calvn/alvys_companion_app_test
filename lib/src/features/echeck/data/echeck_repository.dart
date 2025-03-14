import '../domain/accessorial_types/accessorial_types.dart';

import '../../../constants/api_routes.dart';
import '../domain/generate_echeck/generate_echeck_request.dart';
import '../../trips/domain/app_trip/echeck.dart';
import '../../../network/http_client.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eCheckRepoProvider = Provider<EcheckRepository>((ref) {
  return EcheckRepository(ref.read(httpClientProvider));
});

class EcheckRepository {
  final AlvysHttpClient httpClient;

  EcheckRepository(this.httpClient);
  Future<ECheck> generateEcheck<T>(String companyCode, GenerateECheckRequest request) async {
    var res = await httpClient.postData<T>(ApiRoutes.generateEcheck, companyCode,
        body: request.toJson().toJsonEncodedString);
    return ECheck.fromJson(res.body.toDecodedJson);
  }

  Future<ECheck> cancelEcheck<T>(String companyCode, String echeckId) async {
    var res = await httpClient.patchData<T>(ApiRoutes.cancelEcheck(echeckId), companyCode);
    return ECheck.fromJson(res.body.toDecodedJson);
  }

  Future<List<GetAccessorialTypesResponse>> getEcheckReasons<T>(String companyCode) async {
    var res = await httpClient.getData<T>(ApiRoutes.echeckReasons, companyCode);
    return (res.body.toDecodedJson as List)
        .map((x) => GetAccessorialTypesResponse.fromJson(x))
        .toList();
  }
}
