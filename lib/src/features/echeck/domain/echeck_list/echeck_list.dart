import 'package:freezed_annotation/freezed_annotation.dart';

import 'datum.dart';

part 'echeck_list.freezed.dart';
part 'echeck_list.g.dart';

@freezed
class EcheckList with _$EcheckList {
  factory EcheckList({
    @JsonKey(name: 'Data') List<Datum>? data,
    @JsonKey(name: 'ErrorCode') int? errorCode,
  }) = _EcheckList;

  factory EcheckList.fromJson(Map<String, dynamic> json) =>
      _$EcheckListFromJson(json);
}
