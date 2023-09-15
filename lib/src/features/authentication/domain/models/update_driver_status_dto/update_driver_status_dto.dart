import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_driver_status_dto.freezed.dart';
part 'update_driver_status_dto.g.dart';

@freezed
class UpdateDriverStatusDTO with _$UpdateDriverStatusDTO {
  factory UpdateDriverStatusDTO({
    required String status,
    required String id,
    required double latitude,
    required double longitude,
  }) = _UpdateDriverStatusDTO;

  factory UpdateDriverStatusDTO.fromJson(Map<String, dynamic> json) => _$UpdateDriverStatusDTOFromJson(json);
}
