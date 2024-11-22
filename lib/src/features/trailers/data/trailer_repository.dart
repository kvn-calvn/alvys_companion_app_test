import '../../../constants/api_routes.dart';
import '../domain/trailer_request/trailer_request.dart';
import '../domain/trailer_result/trailer_result.dart';
import '../presentation/controller/search_trailer_controller.dart';
import '../../../network/http_client.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class ITrailerRepository<T> {
  final AlvysHttpClient httpClient;
  ITrailerRepository(this.httpClient);
  Future<List<SuggestTrailer>> getSuggestTrailers(String companyCode, String text) async {
    var res = await httpClient.postData<T>(
      ApiRoutes.suggestTrailers,
      companyCode,
      body: SuggestTrailerRequest(text: text).toJson().toJsonEncodedString,
    );
    return (res.body.toDecodedJson as List).map((x) => SuggestTrailer.fromJson(x)).toList();
  }

  Future<bool> assigntrailer(String companyCode, AssignTrailerDto dto) async {
    await httpClient.putData<T>(
      ApiRoutes.assignTrailer,
      companyCode,
      body: dto.toJson().toJsonEncodedString,
    );
    return true;
  }
}

class TrailerRepository extends ITrailerRepository<SearchTrailerController> {
  TrailerRepository(super.httpClient);
}

final tripTrailerRepositoryProvider = Provider<TrailerRepository>((ref) {
  return TrailerRepository(ref.read(httpClientProvider));
});
