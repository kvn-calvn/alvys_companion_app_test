import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_documents.freezed.dart';
part 'app_documents.g.dart';

@freezed
class AppDocuments with _$AppDocuments {
  factory AppDocuments({
    @JsonKey(name: 'Link') String? link,
    @JsonKey(name: 'Type') String? type,
    @JsonKey(name: 'FileName') String? fileName,
    @JsonKey(name: 'TenantName') String? tenantName,
  }) = _AppDocuments;

  factory AppDocuments.fromJson(Map<String, dynamic> json) =>
      _$AppDocumentsFromJson(json);
}
