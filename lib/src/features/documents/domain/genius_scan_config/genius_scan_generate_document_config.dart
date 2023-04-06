import 'package:freezed_annotation/freezed_annotation.dart';

part 'genius_scan_generate_document_config.freezed.dart';
part 'genius_scan_generate_document_config.g.dart';

@freezed
class GeniusScanGeneratePDFConfig with _$GeniusScanGeneratePDFConfig {
  factory GeniusScanGeneratePDFConfig({
    @Default(<GeneratePDFPage>[])
    @JsonKey(name: 'pages')
        List<GeneratePDFPage> pages,
  }) = _GeniusScanGeneratePDFConfig;

  factory GeniusScanGeneratePDFConfig.fromJson(Map<String, dynamic> json) =>
      _$GeniusScanGeneratePDFConfigFromJson(json);
}

@freezed
class GeneratePDFPage with _$GeneratePDFPage {
  factory GeneratePDFPage({
    @Default('') @JsonKey(name: 'imageUrl') String imageUrl,
  }) = _GeneratePDFPage;

  factory GeneratePDFPage.fromJson(Map<String, dynamic> json) =>
      _$GeneratePDFPageFromJson(json);
  static Map<String, dynamic> toJ(GeneratePDFPage data) => data.toJson();
  static String toPathString(String path) => "file://$path";
}
