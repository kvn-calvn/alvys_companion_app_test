import 'package:freezed_annotation/freezed_annotation.dart';

import 'm_comodity.dart';
import 'reference.dart';
import 'time_record.dart';

part 'data.freezed.dart';
part 'data.g.dart';

@freezed
class Data with _$Data {
  factory Data({
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
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}
