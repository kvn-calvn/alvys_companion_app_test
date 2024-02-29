import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import '../../../../models/address/address.dart';
import '../../../../utils/exceptions.dart';
import '../../../../utils/magic_strings.dart';
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

  DateFormat get stopTimeFormat => DateFormat('MMM d, yyyy @ HH:mm');
  DateFormat get oldStopDateFormat => DateFormat(appointment.isNullOrEmpty ? 'MMM d, yyyy' : 'MMM d, yyyy @ HH:mm');
  bool canCheckIn(String? checkInStopId) => checkInStopId == stopId && timeRecord?.driver?.timeIn == null;

  bool canCheckOut(String? checkOutStopId) =>
      checkOutStopId == stopId && timeRecord?.driver?.timeIn != null && timeRecord?.driver?.timeOut == null;

  bool canCheckInNew(String? checkInStopId) => checkInStopId == stopId && arrived == null;

  bool canCheckOutNew(String? checkOutStopId) => checkOutStopId == stopId && arrived != null && departed == null;
  StopTimeArgs get formattedStopDate {
    return switch (scheduleType?.toUpperCase()) {
      ScheduleType.firstComeFirstServe => firstComeFirstServe,
      ScheduleType.appointment => appointmentDateTime,
      _ => StopTimeArgs(title: '', date: oldStopDateFormat.formatNullDate(stopDate))
    };
  }

  StopTimeArgs get firstComeFirstServe {
    return scheduleType.equalsIgnoreCase(ScheduleType.firstComeFirstServe) && stopWindowBegin.isNotNull
        ? StopTimeArgs(
            title: '${ScheduleType.firstComeFirstServe.toUpperCase()}: ',
            date:
                '${stopTimeFormat.formatNullDate(stopWindowBegin?.localDate)}${stopWindowEnd.isNotNull ? '\n${stopTimeFormat.formatNullDate(stopWindowEnd?.localDate)}' : ''}')
        : StopTimeArgs.empty();
  }

  StopTimeArgs get appointmentDateTime {
    return scheduleType.equalsIgnoreCase(ScheduleType.appointment) && appointmentDate.isNotNull
        ? StopTimeArgs(
            title: '${ScheduleType.appointment.toUpperCase()}: ',
            date: stopTimeFormat.formatNullDate(appointmentDate?.localDate))
        : StopTimeArgs.empty();
  }

  String get tripCardAddress {
    if (address == null) return "-";
    return '${address!.street.isNotNullOrEmpty ? address!.street : "-"} \n${address!.city.isNotNullOrEmpty ? address!.city : "-"}, ${address!.state.isNotNullOrEmpty ? address!.state : "-"} ${address!.zip.isNotNullOrEmpty ? address!.zip : ""}';
  }

  bool get validCoordinates {
    return longitude.isNotNullOrEmpty && latitude.isNotNullOrEmpty;
  }

  void validateCoordinates() {
    if (!validCoordinates) {
      throw AlvysException(
          "The stop you're trying to check into has invalid coordinates. Unable to validate your proximity to the stop. Contact your dispatcher and have them address the invalid cordinates on stop ${companyName ?? ""}",
          "Stop Coordinate Error",
          () {});
    }
  }
}

class StopTimeArgs {
  final String title, date;

  StopTimeArgs({required this.title, required this.date});

  StopTimeArgs.empty()
      : date = '',
        title = '';
  bool get isEmpty => date.isEmpty && title.isEmpty;

  @override
  String toString() {
    return title + date;
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
