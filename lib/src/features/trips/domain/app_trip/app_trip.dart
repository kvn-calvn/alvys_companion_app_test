import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';

import '../../../documents/domain/app_document/app_document.dart';
import 'payable_driver.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'echeck.dart';
import 'stop.dart';
part 'app_trip.freezed.dart';
part 'app_trip.g.dart';

@freezed
class AppTrip with _$AppTrip {
  factory AppTrip({
    @JsonKey(name: 'OrderNumber') String? orderNumber,
    @JsonKey(name: 'Id') String? id,
    @JsonKey(name: 'LoadId') String? loadId,
    @JsonKey(name: 'Dispatch') String? dispatch,
    @JsonKey(name: 'CompanyCode') String? companyCode,
    @JsonKey(name: 'DispatcherId') String? dispatcherId,
    @JsonKey(name: 'DispatchPhone') String? dispatchPhone,
    @JsonKey(name: 'DispatchEmail') String? dispatchEmail,
    @JsonKey(name: 'FirstStopAddress') String? firstStopAddress,
    @JsonKey(name: 'LastStopAddress') String? lastStopAddress,
    @JsonKey(name: 'Equipment') String? equipment,
    @JsonKey(name: 'EquipmentLength') String? equipmentLength,
    @JsonKey(name: 'LoadNumber') String? loadNumber,
    @JsonKey(name: 'TripNumber') String? tripNumber,
    @JsonKey(name: 'Status') String? status,
    @JsonKey(name: 'Rate') double? rate,
    @JsonKey(name: 'TripValue') double? tripValue,
    @JsonKey(name: 'LoadRate') double? loadRate,
    @JsonKey(name: 'PayableDriverAmounts') List<PayableDriverAmount>? payableDriverAmounts,
    @JsonKey(name: 'IsOOP') bool? isOop,
    @JsonKey(name: 'GeneralInstructions') String? generalInstructions,
    @JsonKey(name: 'TotalMiles') double? totalMiles,
    @JsonKey(name: 'TotalWeight') double? totalWeight,
    @JsonKey(name: 'Temperature') double? temperature,
    @JsonKey(name: 'Drivers') List<String?>? drivers,
    @JsonKey(name: 'Stops') List<Stop>? stops,
    @JsonKey(name: 'Echecks') List<ECheck>? eChecks,
    @Default(0) @JsonKey(name: 'StopCount') int stopCount,
    @JsonKey(name: 'PickupDate') DateTime? pickupDate,
    @JsonKey(name: 'DeliveryDate') DateTime? deliveryDate,
    @JsonKey(name: 'EmptyMiles') double? emptyMiles,
    @JsonKey(name: 'TruckId') String? truckId,
    @JsonKey(name: 'LoadType') String? loadType,
    @JsonKey(name: 'TruckNum') String? truckNum,
    @JsonKey(name: 'TrailerId') String? trailerId,
    @JsonKey(name: 'TrailerNum') String? trailerNum,
    @JsonKey(name: 'TripValueDriver') String? tripValueDriver,
    @JsonKey(name: 'Driver1Id') String? driver1Id,
    @JsonKey(name: 'Driver2Id') String? driver2Id,
    @JsonKey(name: 'Driver1Paid') bool? driver1Paid,
    @JsonKey(name: 'Driver2Paid') bool? driver2Paid,
    @JsonKey(name: 'Continuous') bool? continuous,
    @JsonKey(name: 'IsTripActive') bool? isTripActive,
    @JsonKey(name: 'PaidMiles') double? paidMiles,
    @JsonKey(name: 'Attachments') @Default([]) List<AppDocument> attachments,
  }) = _AppTrip;

  factory AppTrip.fromJson(Map<String, dynamic> json) => _$AppTripFromJson(json);

  AppTrip._();

  String? get canCheckInOutStopId => stops
      ?.firstWhereOrNull(
          (element) => element.timeRecord?.driver?.timeIn == null || element.timeRecord?.driver?.timeOut == null)
      ?.stopId;
}
