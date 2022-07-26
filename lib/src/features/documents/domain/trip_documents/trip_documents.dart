import 'package:freezed_annotation/freezed_annotation.dart';

import 'datum.dart';

part 'trip_documents.freezed.dart';
part 'trip_documents.g.dart';

@freezed
class TripDocuments with _$TripDocuments {
  factory TripDocuments({
    @JsonKey(name: 'Data') List<Datum>? data,
    @JsonKey(name: 'ErrorMessage') String? errorMessage,
    @JsonKey(name: 'ErrorCode') int? errorCode,
  }) = _TripDocuments;

  factory TripDocuments.fromJson(Map<String, dynamic> json) =>
      _$TripDocumentsFromJson(json);
}
