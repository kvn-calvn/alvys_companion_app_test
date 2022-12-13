import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_documents.freezed.dart';
part 'trip_documents.g.dart';

@freezed
class TripDocuments with _$TripDocuments {
  factory TripDocuments({
    @JsonKey(name: 'Link') String? link,
    @JsonKey(name: 'Type') String? type,
    @JsonKey(name: 'FileName') String? fileName,
  }) = _TripDocuments;

  factory TripDocuments.fromJson(Map<String, dynamic> json) =>
      _$TripDocumentsFromJson(json);
}
