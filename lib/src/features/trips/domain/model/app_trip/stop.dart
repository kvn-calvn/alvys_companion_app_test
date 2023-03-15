import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:alvys3/src/features/trips/domain/model/stop_details/reference.dart';
import 'm_comodity.dart';
import 'time_record.dart';

part 'stop.freezed.dart';
part 'stop.g.dart';

@freezed
class Stop with _$Stop {
  const factory Stop({
    @JsonKey(name: 'CompanyName') String? companyName,
    @JsonKey(name: 'Street') String? street,
    @JsonKey(name: 'State') String? state,
    @JsonKey(name: 'Zip') String? zip,
    @JsonKey(name: 'City') String? city,
    @JsonKey(name: 'Phone') String? phone,
    @JsonKey(name: 'StopDate') DateTime? stopDate,
    @JsonKey(name: 'ActualStopdate') DateTime? actualStopdate,
    @JsonKey(name: 'Status') String? status,
    @JsonKey(name: 'Appointment') String? appointment,
    @JsonKey(name: 'MComodities') List<MComodity>? mComodities,
    @JsonKey(name: 'Notes') List<dynamic>? notes,
    @JsonKey(name: 'References') List<Reference>? references,
    @JsonKey(name: 'Instructions') String? instructions,
    @JsonKey(name: 'GenInstructions') String? genInstructions,
    @JsonKey(name: 'TimeRecord') TimeRecord? timeRecord,
    @JsonKey(name: 'StopId') String? stopId,
    @JsonKey(name: 'StopType') String? stopType,
    @JsonKey(name: 'Latitude') String? latitude,
    @JsonKey(name: 'Longitude') String? longitude,
  }) = _Stop;

  factory Stop.fromJson(Map<String, dynamic> json) => _$StopFromJson(json);
}
