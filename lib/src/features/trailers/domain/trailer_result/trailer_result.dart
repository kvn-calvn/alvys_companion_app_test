import 'package:freezed_annotation/freezed_annotation.dart';

part 'trailer_result.freezed.dart';
part 'trailer_result.g.dart';

@freezed
class SuggestTrailer with _$SuggestTrailer {
  factory SuggestTrailer({
    required String id,
    @JsonKey(name: "TrailerNum") required String trailerNum,
    @JsonKey(name: "Status") required String status,
  }) = _SuggestTrailer;

  factory SuggestTrailer.fromJson(Map<String, dynamic> json) => _$SuggestTrailerFromJson(json);
}
