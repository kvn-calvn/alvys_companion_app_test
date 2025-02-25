import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../features/trailers/domain/trailer_request/trailer_request.dart';

part 'posthog_objects.freezed.dart';
part 'posthog_objects.g.dart';

@freezed
class PostHogTrailerLog with _$PostHogTrailerLog {
  factory PostHogTrailerLog({
    @JsonKey(name: 'trailer_number') required String trailerNumber,
    @JsonKey(name: 'trip_number') required String tripNumber,
    @JsonKey(name: 'trip_id') required String tripId,
    required String tenant,
  }) = _PostHogTrailerLog;

  factory PostHogTrailerLog.fromJson(Map<String, dynamic> json) => _$PostHogTrailerLogFromJson(json);
  PostHogTrailerLog._();
  factory PostHogTrailerLog.fromSetTrailerDto(SetTrailerDto dto) => PostHogTrailerLog(
      tenant: dto.companyCode, tripNumber: dto.tripNumber, trailerNumber: dto.trailerNumber, tripId: dto.tripId);
}

@freezed
class PosthogEcheckLog with _$PosthogEcheckLog {
  factory PosthogEcheckLog({
    @JsonKey(name: 'echeck_number') required String echeckNumber,
    required String tenant,
    @JsonKey(name: 'trip_number') required String tripNumber,
    @JsonKey(name: 'trip_id') required String tripId,
  }) = _PosthogEcheckLog;

  factory PosthogEcheckLog.fromJson(Map<String, dynamic> json) => _$PosthogEcheckLogFromJson(json);
}

@freezed
class PosthogAddressLog with _$PosthogAddressLog {
  factory PosthogAddressLog(
      {required String address,
      required String tenant,
      @JsonKey(name: 'trip_number') required String tripNumber,
      @JsonKey(name: 'trip_id') required String tripId,
      @JsonKey(name: 'stop_name', includeIfNull: false) required String? stopName,
      @JsonKey(name: 'stop_id') required String stopId}) = _PosthogAddressLog;

  factory PosthogAddressLog.fromJson(Map<String, dynamic> json) => _$PosthogAddressLogFromJson(json);
}

@freezed
class PosthogDocumentUploadLog with _$PosthogDocumentUploadLog {
  factory PosthogDocumentUploadLog({
    @JsonKey(includeIfNull: false) String? tenant,
    @JsonKey(name: 'trip_number', includeIfNull: false) String? tripNumber,
    @JsonKey(name: 'trip_id', includeIfNull: false) String? tripId,
    @JsonKey(name: 'document_type') required String documentType,
    @JsonKey(name: 'file_size') required String fileSize,
  }) = _PosthogDocumentUploadLog;

  factory PosthogDocumentUploadLog.fromJson(Map<String, dynamic> json) => _$PosthogDocumentUploadLogFromJson(json);
}

@freezed
class PosthotEcheckGeneratedLog with _$PosthotEcheckGeneratedLog {
  factory PosthotEcheckGeneratedLog({
    required String tenant,
    @JsonKey(name: 'trip_number') required String tripNumber,
    @JsonKey(name: 'trip_id') required String tripId,
    @JsonKey(name: 'stop_name', includeIfNull: false) required String? stopName,
    @JsonKey(name: 'stop_id', includeIfNull: false) required String? stopId,
    required String reason,
    required String success,
    required String note,
    required double amount,
  }) = _PosthotEcheckGeneratedLog;

  factory PosthotEcheckGeneratedLog.fromJson(Map<String, dynamic> json) => _$PosthotEcheckGeneratedLogFromJson(json);
}

@freezed
class PosthogTimeRecordLog with _$PosthogTimeRecordLog {
  factory PosthogTimeRecordLog({
    required String tenant,
    @JsonKey(name: 'trip_number') required String tripNumber,
    @JsonKey(name: 'trip_id') required String tripId,
    @JsonKey(name: 'load_number') required String loadNumber,
    @JsonKey(includeIfNull: false) required bool? success,
    required String distance,
    required String location, 
    required String stopId, required String stopName,
  }) = _PosthogTimeRecordLog;

  factory PosthogTimeRecordLog.fromJson(Map<String, dynamic> json) => _$PosthogTimeRecordLogFromJson(json);
}
