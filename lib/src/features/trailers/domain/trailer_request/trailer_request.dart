import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trailer_request.freezed.dart';
part 'trailer_request.g.dart';

@freezed
class SuggestTrailerRequest with _$SuggestTrailerRequest {
  factory SuggestTrailerRequest({
    @JsonKey(name: "SuggestionText") required String text,
  }) = _SuggestTrailerRequest;

  factory SuggestTrailerRequest.fromJson(Map<String, dynamic> json) => _$SuggestTrailerRequestFromJson(json);
}

@freezed
class AssignTrailerDto with _$AssignTrailerDto {
  factory AssignTrailerDto({
    @JsonKey(name: "TripId") required String tripId,
    @JsonKey(name: "TrailerId") required String trailerId,
  }) = _AssignTrailerDto;

  factory AssignTrailerDto.fromJson(Map<String, dynamic> json) => _$AssignTrailerDtoFromJson(json);
}

@freezed
class SetTrailerDto with _$SetTrailerDto {
  factory SetTrailerDto({
    required String trailerNumber,
    required String companyCode,
    required String tripId,
    required String trailerId,
    required String tripNumber,
  }) = _SetTrailerDto;
  factory SetTrailerDto.fromJson(Map<String, dynamic> json) => _$SetTrailerDtoFromJson(json);
  SetTrailerDto._();
  bool get isValid => trailerNumber.isNotNullOrEmptyWhiteSpace && trailerId.isNotNullOrEmptyWhiteSpace;
}
