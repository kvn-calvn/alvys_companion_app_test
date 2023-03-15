import 'package:freezed_annotation/freezed_annotation.dart';

import 'time_record.dart';

part 'mini_stop.freezed.dart';
part 'mini_stop.g.dart';

@freezed
class MiniStop with _$MiniStop {
  factory MiniStop({
    @JsonKey(name: 'CompanyName') String? companyName,
    @JsonKey(name: 'Street') String? street,
    @JsonKey(name: 'State') String? state,
    @JsonKey(name: 'Zip') String? zip,
    @JsonKey(name: 'City') String? city,
    @JsonKey(name: 'Phone') String? phone,
    @JsonKey(name: 'StopDate') String? stopDate,
    @JsonKey(name: 'ActualStopdate') String? actualStopdate,
    @JsonKey(name: 'Status') String? status,
    @JsonKey(name: 'Appointment') String? appointment,
    @JsonKey(name: 'TimeRecord') TimeRecord? timeRecord,
    @JsonKey(name: 'StopId') String? stopId,
    @JsonKey(name: 'StopType') String? stopType,
    @JsonKey(name: 'Latitude') String? latitude,
    @JsonKey(name: 'Longitude') String? longitude,
  }) = _MiniStop;

  factory MiniStop.fromJson(Map<String, dynamic> json) =>
      _$MiniStopFromJson(json);
}
