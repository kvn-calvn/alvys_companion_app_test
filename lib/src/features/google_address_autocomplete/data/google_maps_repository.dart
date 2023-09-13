import '../domain/google_places_details_result.dart';

import '../../../../flavor_config.dart';
import '../domain/google_places_result.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:http/http.dart';

class GoogleMapsRepo {
  static String get googleMapsKey => FlavorConfig.instance!.gMapsKey;

  static Future<GooglePlacesResults> searchAddresses(String text) async {
    var url =
        Uri.https('maps.googleapis.com', '/maps/api/place/autocomplete/json', {'input': text, 'key': googleMapsKey});
    var res = await get(url);
    if (res.statusCode != 200) return GooglePlacesResults(predictions: [], status: 'ERROR');
    return GooglePlacesResults.fromJson(res.body.toDecodedJson);
  }

  static Future<GooglePlacesDetailsResult> getPlaceDetails(String placeId) async {
    var url =
        Uri.https('maps.googleapis.com', '/maps/api/place/details/json', {'place_id': placeId, 'key': googleMapsKey});
    var res = await get(url);
    if (res.statusCode != 200) {
      return GooglePlacesDetailsResult(
        result: GooglePlacesResult(addressComponents: [], placeId: placeId),
        status: 'ERROR',
      );
    }
    return GooglePlacesDetailsResult.fromJson(res.body.toDecodedJson);
  }
}
