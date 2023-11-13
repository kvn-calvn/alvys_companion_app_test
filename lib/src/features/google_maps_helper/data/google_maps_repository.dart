import 'dart:convert';
import 'dart:ui';

import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flexible_polyline/flexible_polyline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

import '../../../../flavor_config.dart';
import '../domain/google_places_details_result.dart';
import '../domain/google_places_result.dart';

final googleMapsRepo = Provider<GoogleMapsRepo>((ref) => GoogleMapsRepo());

class GoogleMapsRepo {
  static String get googleMapsKey => FlavorConfig.instance!.gMapsKey;
  static String get baseUrl => 'maps.googleapis.com';
  static Future<GooglePlacesResults> searchAddresses(String text) async {
    var url = Uri.https(baseUrl, '/maps/api/place/autocomplete/json', {'input': text, 'key': googleMapsKey});
    var res = await get(url);
    if (res.statusCode != 200) {
      return GooglePlacesResults(predictions: [], status: 'ERROR');
    }
    return GooglePlacesResults.fromJson(res.body.toDecodedJson);
  }

  static Future<GooglePlacesDetailsResult> getPlaceDetails(String placeId) async {
    var url = Uri.https(baseUrl, '/maps/api/place/details/json', {'place_id': placeId, 'key': googleMapsKey});
    var res = await get(url);
    if (res.statusCode != 200) {
      return GooglePlacesDetailsResult(
        result: GooglePlacesResult(addressComponents: [], placeId: placeId),
        status: 'ERROR',
      );
    }
    return GooglePlacesDetailsResult.fromJson(res.body.toDecodedJson);
  }

  Future<Map<PolylineId, Polyline>> getPolyLines(List<LatLng> coordinates, [String overview = 'simplified']) async {
    var res = <PolylineId, Polyline>{};
    for (int i = 0; i < coordinates.length - 1; i++) {
      var response = await get(
        Uri.parse(
            'https://router.hereapi.com/v8/routes?transportMode=truck&origin=${coordinates[i].latitude},${coordinates[i].longitude}&destination=${coordinates[i + 1].latitude},${coordinates[i + 1].longitude}&return=polyline&apiKey=${FlavorConfig.instance!.hereMapsKey}'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> parsedJson = jsonDecode(response.body);
        String routesPolyline = parsedJson["routes"][0]['sections'][0]['polyline'];

        final coorValues = FlexiblePolyline.decode(routesPolyline);
        List<LatLng> routesPoints = [];
        for (int i = 0; i < coorValues.length; i++) {
          routesPoints.add(LatLng(coorValues[i].lat, coorValues[i].lng));
        }
        PolylineId id = PolylineId("poly$i");
        Polyline polyline = Polyline(
          polylineId: id,
          color: Colors.blueAccent,
          points: routesPoints,
          width: 4,
          onTap: () {},
        );
        res[id] = polyline;
      }
    }

    return res;
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (var latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  Future<Uint8List?> getMapMarkerBytesFromAsset(String path, [int width = 24]) async {
    var w = (WidgetsBinding.instance.platformDispatcher.implicitView!.devicePixelRatio * width).toInt();
    ByteData data = await rootBundle.load(path);
    var codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: w);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))?.buffer.asUint8List();
  }
}
