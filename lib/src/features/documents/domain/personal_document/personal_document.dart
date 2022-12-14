import 'package:freezed_annotation/freezed_annotation.dart';

part 'personal_document.freezed.dart';
part 'personal_document.g.dart';

@freezed
class PersonalDocument with _$PersonalDocument {
  factory PersonalDocument({
    @JsonKey(name: 'Link') String? link,
    @JsonKey(name: 'Type') String? type,
    @JsonKey(name: 'TenantName') String? tenantName,
  }) = _PersonalDocument;

  factory PersonalDocument.fromJson(Map<String, dynamic> json) =>
      _$PersonalDocumentFromJson(json);
}
