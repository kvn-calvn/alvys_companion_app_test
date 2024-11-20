import '../trailer_result/trailer_result.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_trailer_state.freezed.dart';

@freezed
class SearchTrailerState with _$SearchTrailerState {
  factory SearchTrailerState({
    @Default(<SuggestTrailer>[]) List<SuggestTrailer> trailers,
    @Default(true) bool init,
  }) = _SearchTrailerState;

  SearchTrailerState._();
  bool doesMatchInList(String value) => trailers.map((x) => x.trailerNum).containsIgnoreCase(value);

  String? getTrailerId(String value) => trailers.firstWhereOrNull((x) => x.trailerNum.equalsIgnoreCase(value))?.id;
}
