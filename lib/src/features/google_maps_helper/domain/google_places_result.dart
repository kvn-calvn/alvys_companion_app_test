import 'package:freezed_annotation/freezed_annotation.dart';

import 'google_places_prediction.dart';

part 'google_places_result.freezed.dart';
part 'google_places_result.g.dart';

@freezed
class GooglePlacesResults with _$GooglePlacesResults {
  factory GooglePlacesResults({required List<GooglePlacesPrediction> predictions, required String status}) =
      _GooglePlacesResults;

  factory GooglePlacesResults.fromJson(Map<String, dynamic> json) => _$GooglePlacesResultsFromJson(json);
}
