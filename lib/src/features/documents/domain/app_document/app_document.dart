import '../../../../../flavor_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_document.freezed.dart';
part 'app_document.g.dart';

@freezed
class AppDocument with _$AppDocument {
  factory AppDocument({
    @JsonKey(name: "CompanyCode") required String companyCode,
    @JsonKey(name: "DocumentPath") required String documentPath,
    @JsonKey(name: "CompanyName") required String companyName,
    @JsonKey(name: "DocumentType") required String documentType,
    @JsonKey(name: "Date") DateTime? date,
  }) = _AppDocument;

  factory AppDocument.fromJson(Map<String, dynamic> json) => _$AppDocumentFromJson(json);

  AppDocument._();

  String get documentUrl => '${FlavorConfig.instance!.storageUrl}${companyCode.toLowerCase()}/$documentPath';
}

@freezed
class DriverPaystubDTO with _$DriverPaystubDTO {
  factory DriverPaystubDTO(
      {@JsonKey(name: 'Top') required String top,
      @JsonKey(name: 'DriverId') required String driverId}) = _DriverPaystubDTO;

  factory DriverPaystubDTO.fromJson(Map<String, dynamic> json) => _$DriverPaystubDTOFromJson(json);
}

@freezed
class DriverDocumentsDTO with _$DriverDocumentsDTO {
  factory DriverDocumentsDTO({
    @JsonKey(name: 'AcceptedTypes') required List<String> acceptedTypes,
    @JsonKey(name: 'AssetId') required String driverId,
  }) = _DriverDocumentsDTO;

  factory DriverDocumentsDTO.fromJson(Map<String, dynamic> json) => _$DriverDocumentsDTOFromJson(json);
}
