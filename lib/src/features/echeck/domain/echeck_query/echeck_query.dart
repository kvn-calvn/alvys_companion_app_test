import 'package:freezed_annotation/freezed_annotation.dart';

import 'data.dart';

part 'echeck_query.freezed.dart';
part 'echeck_query.g.dart';

@freezed
class EcheckQuery with _$EcheckQuery {
  factory EcheckQuery({
    @JsonKey(name: 'Data') Data? data,
    @JsonKey(name: 'ErrorCode') int? errorCode,
  }) = _EcheckQuery;

  factory EcheckQuery.fromJson(Map<String, dynamic> json) =>
      _$EcheckQueryFromJson(json);
}
