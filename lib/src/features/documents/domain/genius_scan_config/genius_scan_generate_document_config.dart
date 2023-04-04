import 'package:freezed_annotation/freezed_annotation.dart';

part 'genius_scan_generate_document_config.freezed.dart';
part 'genius_scan_generate_document_config.g.dart';

@freezed
class GeniusScanGeneratePDFConfig with _$GeniusScanGeneratePDFConfig {
  factory GeniusScanGeneratePDFConfig({
    @Default(<GeneratePDFPage>[]) GeneratePDFPage pages,
  }) = _GeniusScanGeneratePDFConfig;

  factory GeniusScanGeneratePDFConfig.fromJson(Map<String, dynamic> json) =>
      _$GeniusScanGeneratePDFConfigFromJson(json);
}

@freezed
class GeneratePDFPage with _$GeneratePDFPage {
  factory GeneratePDFPage({
    @Default('') String imageUrl,
  }) = _GeneratePDFPage;

  factory GeneratePDFPage.fromJson(Map<String, dynamic> json) =>
      _$GeneratePDFPageFromJson(json);
}
