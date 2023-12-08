import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import '../../../../models/address/address.dart';
import 'm_comodity.dart';
import 'reference.dart';
import 'time_record.dart';

part 'stop.freezed.dart';
part 'stop.g.dart';

@freezed
class Stop with _$Stop {
  const factory Stop({
    @JsonKey(name: 'CompanyName') String? companyName,
    @JsonKey(name: 'Phone') String? phone,
    @JsonKey(name: 'StopAddress') @Default('') String stopAddress,
    @JsonKey(name: 'StopDate') DateTime? stopDate,
    @JsonKey(name: 'ActualStopdate') DateTime? actualStopdate,
    @JsonKey(name: 'Status') String? status,
    @JsonKey(name: 'Appointment') String? appointment,
    @JsonKey(name: 'Comodities') List<MComodity>? comodities,
    @JsonKey(name: 'Notes') List<Note>? notes,
    @JsonKey(name: 'References') List<Reference>? references,
    @JsonKey(name: 'Instructions') String? instructions,
    @JsonKey(name: 'GeneralInstructions') String? genInstructions,
    @JsonKey(name: 'TimeRecord') TimeRecord? timeRecord,
    @JsonKey(name: 'StopId') String? stopId,
    @JsonKey(name: 'StopType') String? stopType,
    @JsonKey(name: 'Latitude') String? latitude,
    @JsonKey(name: 'Longitude') String? longitude,
    @JsonKey(name: 'LoadingType') String? loadingType,
    @JsonKey(name: 'Address') Address? address,
    @JsonKey(name: 'CompanyShippingHours') String? companyShippingHours,
    @JsonKey(name: 'ScheduleType') String? scheduleType,
    @JsonKey(name: 'AppointmentDate') DateTimeTZ? appointmentDate,
    @JsonKey(name: 'StopWindowBegin') DateTimeTZ? stopWindowBegin,
    @JsonKey(name: 'StopWindowEnd') DateTimeTZ? stopWindowEnd,
    @JsonKey(name: 'ETA') DateTimeTZ? eta,
    @JsonKey(name: 'Arrived') DateTimeTZ? arrived,
    @JsonKey(name: 'Departed') DateTimeTZ? departed,
  }) = _Stop;

  factory Stop.fromJson(Map<String, dynamic> json) => _$StopFromJson(json);
  const Stop._();
  bool canCheckIn(String? checkInStopId) => checkInStopId == stopId && timeRecord?.driver?.timeIn == null;

  bool canCheckOut(String? checkOutStopId) =>
      checkOutStopId == stopId && timeRecord?.driver?.timeIn != null && timeRecord?.driver?.timeOut == null;

  bool canCheckInNew(String? checkInStopId) => checkInStopId == stopId && arrived == null;

  bool canCheckOutNew(String? checkOutStopId) => checkOutStopId == stopId && arrived != null && departed == null;
  String get formattedStopDate {
    if (stopDate == null) return '-';
    var format = appointment.isNullOrEmpty ? 'MMM d, yyyy' : 'MMM d, yyyy @ HH:mm';
    return DateFormat(format).format(appointmentDate?.localDate ?? stopDate!) + timeWindow;
  }

  String get timeWindow {
    var timeFormat = DateFormat('HH:mm');
    return scheduleType.equalsIgnoreCase(ScheduleType.firstComeFirstServe) && stopWindowBegin.isNotNull
        ? '\n(${timeFormat.formatNullDate(stopWindowBegin?.localDate)}${stopWindowEnd.isNotNull ? ' - ${timeFormat.formatNullDate(stopWindowEnd?.localDate)}' : ''}) ${ScheduleType.firstComeFirstServe.toUpperCase()}'
        : "";
  }

  String get tripCardAddress {
    if (address == null) return "-";
    return '${address!.street.isNotNullOrEmpty ? address!.street : "-"} \n${address!.city.isNotNullOrEmpty ? address!.city : "-"}, ${address!.state.isNotNullOrEmpty ? address!.state : "-"} ${address!.zip.isNotNullOrEmpty ? address!.zip : ""}';
  }
}

@freezed
class Note with _$Note {
  factory Note({
    @JsonKey(name: 'Description') String? description,
    @JsonKey(name: 'NoteType') String? noteType,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}

@freezed
class DateTimeTZ with _$DateTimeTZ {
  factory DateTimeTZ({
    @JsonKey(name: 'LocalDate') required DateTime localDate,
    @JsonKey(name: 'UtcDate') required DateTime utcDate,
    @JsonKey(name: 'OffsetMinutes') required int offsetMinutes,
    @JsonKey(name: 'TimeZoneId') required String timeZoneId,
  }) = _DateTimeTZ;

  factory DateTimeTZ.fromJson(Map<String, dynamic> json) => _$DateTimeTZFromJson(json);
}
