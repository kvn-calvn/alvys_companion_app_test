import 'package:freezed_annotation/freezed_annotation.dart';

part 'google_places_prediction.freezed.dart';
part 'google_places_prediction.g.dart';

@freezed
class GooglePlacesPrediction with _$GooglePlacesPrediction {
  factory GooglePlacesPrediction({required String description, @JsonKey(name: 'place_id') String? placeId}) =
      _GooglePlacesPrediction;

  factory GooglePlacesPrediction.fromJson(Map<String, dynamic> json) => _$GooglePlacesPredictionFromJson(json);
}
