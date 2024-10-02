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
    var res =
        await httpClient.postData<T>(ApiRoutes.generateEcheck, companyCode, body: request.toJson().toJsonEncodedString);

        
  
    return ECheck.fromJson(res.body.toDecodedJson);
  }

  Future<ECheck> cancelEcheck<T>(String companyCode, String checkNumber) async {
    var res = await httpClient.patchData<T>(ApiRoutes.cancelEcheck(checkNumber), companyCode);
    return ECheck.fromJson(res.body.toDecodedJson);
  }
}
