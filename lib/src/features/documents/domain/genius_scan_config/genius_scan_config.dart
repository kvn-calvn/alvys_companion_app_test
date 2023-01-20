import 'package:alvys3/src/utils/extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'genius_scan_config.freezed.dart';
part 'genius_scan_config.g.dart';

@freezed
class GeniusScanConfig with _$GeniusScanConfig {
  factory GeniusScanConfig({
    String? source,
    String? sourceImageUrl,
    @Default(true) bool multiPage,
    String? defaultFilter,
    @Default('letter') String pdfPageSize,
    String? pdfMaxScanDimension,
    String? jpegQuality,
    String? postProcessingActions,
    @Default(false) bool flashButtonHidden,
    String? defaultFlashMode,
    String? foregroundColor,
    String? backgroundColor,
    String? highlightColor,
    String? menuColor,
  }) = _GeniusScanConfig;

  factory GeniusScanConfig.fromJson(Map<String, dynamic> json) =>
      _$GeniusScanConfigFromJson(json);

  factory GeniusScanConfig.camera() => GeniusScanConfig(
        source: 'camera',
        defaultFilter: "blackAndWhite",
        pdfPageSize: "letter",
        defaultFlashMode: "auto",
      );
  factory GeniusScanConfig.gallery(String path) => GeniusScanConfig(
        source: 'image',
        defaultFilter: 'photo',
        sourceImageUrl: 'file://$path',
      );
  @override
  Map<String, dynamic> toJson() {
    return super.toJson().removeNulls;
  }
}

@freezed
class GeniusScanResults with _$GeniusScanResults {
  factory GeniusScanResults({
    String? pdfUrl,
    @Default(<Scan>[]) List<Scan> scans,
  }) = _GeniusScanResults;

  factory GeniusScanResults.fromJson(Map<String, dynamic> json) =>
      _$GeniusScanResultsFromJson(json);
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
