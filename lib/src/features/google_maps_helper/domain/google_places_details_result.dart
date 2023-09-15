import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'google_places_details_result.freezed.dart';
part 'google_places_details_result.g.dart';

@freezed
class GooglePlacesDetailsResult with _$GooglePlacesDetailsResult {
  factory GooglePlacesDetailsResult({
    required GooglePlacesResult result,
    required String status,
  }) = _GooglePlacesDetailsResult;

  factory GooglePlacesDetailsResult.fromJson(Map<String, dynamic> json) => _$GooglePlacesDetailsResultFromJson(json);
}

@freezed
class GooglePlacesResult with _$GooglePlacesResult {
  factory GooglePlacesResult({
    @JsonKey(name: "address_components") required List<GooglePlacesAddressComponent> addressComponents,
    @JsonKey(name: "place_id") required String placeId,
  }) = _GooglePlacesResult;

  factory GooglePlacesResult.fromJson(Map<String, dynamic> json) => _$GooglePlacesResultFromJson(json);

  GooglePlacesResult._();

  String get zip =>
      addressComponents.firstWhereOrNull((element) => element.types.isInIgnoreCase('postal_code'))?.shortName ?? '';

  String get country =>
      addressComponents.firstWhereOrNull((element) => element.types.isInIgnoreCase('country'))?.shortName ?? '';

  String get state =>
      addressComponents
          .firstWhereOrNull((element) => element.types.isInIgnoreCase('administrative_area_level_1'))
          ?.shortName ??
      '';

  String get city =>
      addressComponents.firstWhereOrNull((element) => element.types.isInIgnoreCase('locality'))?.shortName ?? '';
  String get street =>
      '${(addressComponents.firstWhereOrNull((element) => element.types.isInIgnoreCase('street_number'))?.shortName ?? '')} ${(addressComponents.firstWhereOrNull((element) => element.types.isInIgnoreCase('route'))?.shortName ?? '')}'
          .trim();
}

@freezed
class GooglePlacesAddressComponent with _$GooglePlacesAddressComponent {
  factory GooglePlacesAddressComponent({
    @JsonKey(name: "long_name") required String longName,
    @JsonKey(name: "short_name") required String shortName,
    @Default(<String>[]) List<String> types,
  }) = _GooglePlacesAddressComponent;

  factory GooglePlacesAddressComponent.fromJson(Map<String, dynamic> json) =>
      _$GooglePlacesAddressComponentFromJson(json);
}
