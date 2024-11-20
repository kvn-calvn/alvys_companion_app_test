import 'package:freezed_annotation/freezed_annotation.dart';

part 'genius_scan_config.freezed.dart';
part 'genius_scan_config.g.dart';

@freezed
class GeniusScanConfig with _$GeniusScanConfig {
  factory GeniusScanConfig({
    @JsonKey(includeIfNull: false) String? source,
    @JsonKey(includeIfNull: false) String? sourceImageUrl,
    @Default(true) bool multiPage,
    @JsonKey(includeIfNull: false) String? defaultFilter,
    @Default('letter') String pdfPageSize,
    @JsonKey(includeIfNull: false) String? pdfMaxScanDimension,
    @JsonKey(includeIfNull: false) int? jpegQuality,
    @Default(['rotate', 'editFilter', 'correctDistortion']) List<String> postProcessingActions,
    @Default(false) bool flashButtonHidden,
    @JsonKey(includeIfNull: false) String? defaultFlashMode,
    @JsonKey(includeIfNull: false) String? foregroundColor,
    @JsonKey(includeIfNull: false) String? backgroundColor,
    @JsonKey(includeIfNull: false) String? highlightColor,
    @JsonKey(includeIfNull: false) String? menuColor,
  }) = _GeniusScanConfig;

  factory GeniusScanConfig.fromJson(Map<String, dynamic> json) => _$GeniusScanConfigFromJson(json);

  factory GeniusScanConfig.camera() => GeniusScanConfig(
        source: 'camera',
        defaultFilter: "blackAndWhite",
        pdfPageSize: "letter",
        defaultFlashMode: "auto",
        jpegQuality: 100,
      );
  factory GeniusScanConfig.gallery(String? url) => GeniusScanConfig(
        source: 'image',
        defaultFilter: 'blackAndWhite',
        jpegQuality: 100,
        sourceImageUrl: url,
      );
}

@freezed
class GeniusScanResults with _$GeniusScanResults {
  factory GeniusScanResults({
    String? multiPageDocumentUrl,
    @Default(<Scan>[]) List<Scan> scans,
  }) = _GeniusScanResults;

  factory GeniusScanResults.fromJson(Map<String, dynamic> json) => _$GeniusScanResultsFromJson(json);
}

@freezed
class Scan with _$Scan {
  factory Scan({
    String? originalUrl,
    String? enhancedUrl,
  }) = _Scan;

  static String toPathString(String path) => path.replaceAll("file://", "");

  factory Scan.fromJson(Map<String, dynamic> json) => _$ScanFromJson(json);
}
