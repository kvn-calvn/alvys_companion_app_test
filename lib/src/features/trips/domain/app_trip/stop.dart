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
  }) = _Stop;

  factory Stop.fromJson(Map<String, dynamic> json) => _$StopFromJson(json);
  const Stop._();
  bool canCheckIn(String? checkInStopId) => checkInStopId == stopId && timeRecord?.driver?.timeIn == null;

  bool canCheckOut(String? checkOutStopId) =>
      checkOutStopId == stopId && timeRecord?.driver?.timeIn != null && timeRecord?.driver?.timeOut == null;
  String get formattedStopDate {
    if (stopDate == null) return '-';
    var format = companyShippingHours.isNotNullOrEmpty
        ? 'MMM d, yyyy @ $companyShippingHours'
        : appointment.isNullOrEmpty
            ? 'MMM d, yyyy'
            : 'MMM d, yyyy @ HH:mm';
    return DateFormat(format).format(stopDate!);
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
