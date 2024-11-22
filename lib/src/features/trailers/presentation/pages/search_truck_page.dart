import 'dart:async';

import '../../../../../custom_icons/alvys_mobile_icons.dart';
import '../../../../common_widgets/custom_bottom_sheet.dart';
import '../../../../common_widgets/shimmers/search_trailers_List_shimmer.dart';
import '../../domain/search_trailer_state/search_trailer_state.dart';
import '../../domain/trailer_request/trailer_request.dart';
import '../../domain/trailer_result/trailer_result.dart';
import '../controller/search_trailer_controller.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/color.dart';

Future<T?> showSearchTruckSheet<T>(
        {required BuildContext context,
        required SetTrailerDto dto,
        required FutureOr<void> Function(SetTrailerDto trailer) onSelect}) =>
    showCustomBottomSheet<T>(context, SearchTrailerPage(dto, onSelect), constrain: false, isScrollControlled: false);

class SearchTrailerPage extends ConsumerStatefulWidget {
  final SetTrailerDto dto;
  final FutureOr<void> Function(SetTrailerDto trailer) onSelect;
  const SearchTrailerPage(this.dto, this.onSelect, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchTrailerPageState();
}

class _SearchTrailerPageState extends ConsumerState<SearchTrailerPage> {
  Future<void>? searchFuture;
  var focus = FocusNode();
  SearchTrailerController get trailerController => ref.read(searchTrailerControllerProvider.call(widget.dto).notifier);
  AsyncValue<SearchTrailerState> get trailerState => ref.watch(searchTrailerControllerProvider.call(widget.dto));
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  var textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Unfocus(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const SizedBox(
              height: 4,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DefaultTextStyle.merge(
                      child: Text('Trailer Number'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w200)),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      icon: Icon(Icons.close))
                ],
              ),
            ),
            Divider(
              height: 0,
              thickness: 2,
            ),
            Flexible(
              child: Builder(builder: (context) {
                if (trailerState.isLoading) return Center(child: const SearchTrailersListShimmer());
                if (trailerState.value!.init) {
                  return TrailerEmptyView(message: 'Search trailer by number');
                }
                return trailerState.value!.trailers.isEmpty
                    ? TrailerEmptyView(message: 'No trailers found')
                    : Align(
                        alignment: Alignment.topCenter,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ...trailerState.value!.trailers.map((x) => SuggestTrailerItemWidget(
                                    trailer: x,
                                    onTap: () {
                                      trailerController.setTrailer(context, x.trailerNum, widget.onSelect);
                                    },
                                  ))
                            ],
                          ),
                        ),
                      );
              }),
            ),
            Divider(
              height: 0,
              thickness: 2,
            ),
            SafeArea(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Flexible(
                      child: TextFormField(
                    focusNode: focus,
                    style: Theme.of(context).textTheme.bodyMedium,
                    autofocus: true,
                    enabled: !trailerState.isLoading,
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'Enter Number',
                      isDense: false,
                      prefixIconConstraints: BoxConstraints(),
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
                        child: Icon(Icons.search),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotNullOrEmptyWhiteSpace) {
                        trailerController.searchTrailer(value);
                      } else {
                        trailerController.clearTrailers();
                      }
                    },
                  )),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed:
                        (trailerState.value?.doesMatchInList(textController.text) ?? false) && !trailerState.isLoading
                            ? () async {
                                await trailerController.setTrailer(context, textController.text, widget.onSelect);
                              }
                            : null,
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.all(14), elevation: 0),
                    child: Text('Add'),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class SuggestTrailerItemWidget extends StatelessWidget {
  final SuggestTrailer trailer;
  final FutureOr<void> Function() onTap;
  const SuggestTrailerItemWidget({super.key, required this.trailer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: InkWell(
        onTap: () async {
          await onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Row(children: [
            Icon(AlvysMobileIcons.trailer),
            const SizedBox(width: 10),
            Text('#${trailer.trailerNum}'),
          ]),
        ),
      ),
    );
  }
}

class TrailerEmptyView extends StatelessWidget {
  final String message;
  const TrailerEmptyView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(
              AlvysMobileIcons.trailer,
              size: 20,
              color: ColorManager.primary(Theme.of(context).brightness),
            ),
          ),
          const SizedBox(height: 12),
          Text(message)
        ],
      ),
    );
  }
}

var k = {
  "id": "1af0526153d442e2b39f31d05af38577",
  "LoadLane": {
    "Origin": {
      "City": "Jackson Township",
      "State": "NJ",
      "Zip": "08527",
      "Region": null,
      "CompanyId": null,
      "Coordinates": {
        "type": "Point",
        "coordinates": [-74.3578109741211, 40.10917663574219]
      }
    },
    "Destination": {
      "City": "New York",
      "State": "NY",
      "Zip": "10029",
      "Region": null,
      "CompanyId": null,
      "Coordinates": {
        "type": "Point",
        "coordinates": [-73.9745101928711, 40.754547119140625]
      }
    },
    "Lane": "Jackson Township, NJ \u2192 New York, NY"
  },
  "TripLane": {
    "Origin": {
      "City": "Jackson Township",
      "State": "NJ",
      "Zip": "08527",
      "Region": null,
      "CompanyId": null,
      "Coordinates": {
        "type": "Point",
        "coordinates": [-74.3578109741211, 40.10917663574219]
      }
    },
    "Destination": {
      "City": "New York",
      "State": "NY",
      "Zip": "10029",
      "Region": null,
      "CompanyId": null,
      "Coordinates": {
        "type": "Point",
        "coordinates": [-73.9745101928711, 40.754547119140625]
      }
    },
    "Lane": "Jackson Township, NJ \u2192 New York, NY"
  },
  "Load": {
    "id": "9ddecde7f7fe433e8815783b2f530cbe",
    "CompanyCode": "CL358",
    "ETag": "\u002280023c4b-0000-0300-0000-673ccb260000\u0022",
    "LoadNumber": "1002829",
    "OrderNumber": "mbl_app03",
    "PONum": null,
    "Rate": 3000,
    "LaneContractId": null,
    "LaneContractName": null,
    "LaneContractPriority": null,
    "RateOverriden": null,
    "RateOverridenBy": null,
    "LoadBoardRate": null,
    "InvoiceAmount": null,
    "InvoiceSentCount": 0,
    "LastInvoiceSentDate": null,
    "PaymentStatusSentCount": 0,
    "PaymentRequestTimestamp": null,
    "CustomerContact": null,
    "FleetId": "80200ea01c214da19142ec76463f91c2",
    "FleetName": "autoport n14",
    "FleetInvoiceNumberPrefix": null,
    "CustomerId": "749ed780-bc20-40c4-8871-a965353196d3",
    "CustomerType": ["Customer"],
    "Status": "Dispatched",
    "PreviousStatus": "Open",
    "StatusReason": "Load Updated",
    "Notes": [],
    "NotesCount": 0,
    "ReasonNotCompleted": "",
    "ReasonNotInvoiced": null,
    "InvoiceSent": false,
    "InvoiceGenerated": false,
    "OfficeId": "cca5b831-adba-4f85-ada9-10a4912a23b2",
    "IsDeleted": false,
    "DateCreated": "2024-11-19T17:30:13.529+00:00",
    "CreatedBy": "14445c06-698e-4859-83b3-2dc960a8c50b",
    "PickupDate": "2024-11-26T10:00:00+00:00",
    "DeliveryDate": "2024-11-29T14:00:00+00:00",
    "DateDelivered": null,
    "DateInvoiced": null,
    "DateUploaded": null,
    "DueDate": null,
    "DateCancelled": null,
    "StatusChangedAt": "2024-11-19T17:30:43.923+00:00",
    "Instructions": "This a general instruction!",
    "CancelledBy": null,
    "InvoicedBy": null,
    "LockedBy": null,
    "Source": null,
    "IsLocked": null,
    "UploadedToFTP": null,
    "IsRejectedByFactoringCompany": false,
    "CreatedOnBehalfOf": "",
    "CreatedByName": "Automations User - DO NOT DELETE",
    "CreatedOnBehalfOfName": null,
    "SalesAgent": "Automations User - DO NOT DELETE",
    "InvoiceAs": "AUTOPORT LLC",
    "InvoiceAsSubsidiaryId": "262d5144-b873-4971-80c9-e83a94309ad8",
    "SharedWith": {"Users": [], "Groups": []},
    "LoadType": "Revenue",
    "IsPaid": false,
    "HasUpdates": null,
    "IsAcknowledged": null,
    "CustomerPayments": [],
    "PaymentTerm": null,
    "PurchaseReportTransactions": [],
    "Priority": null,
    "TenderId": null,
    "MatchingTenderId": null,
    "FreightBreakdown": [
      {"Type": "Base Rate", "Amount": 3000}
    ],
    "FuelSurchargeEnabled": false,
    "FuelSurchargeContractChanged": false,
    "FuelSurchargeSource": null,
    "FuelSurchargeType": null,
    "FuelSurchargeSubType": null,
    "FuelSurchargeContractId": null,
    "FuelSurchargeContractName": null,
    "FuelSurchargeRate": 0,
    "FuelSurchargeValue": 0,
    "FuelSurchargeAmount": 0,
    "ParentLoadId": null,
    "ParentLoadCompanyCode": null,
    "ChildLoadId": null,
    "ChildLoadCompanyCode": null,
    "HasPendingInvoiceChanges": false,
    "SummaryInvoiceNumber": null,
    "CustomerMileage": {
      "Measurement": {"UnitOfMeasure": "Miles", "Value": 88},
      "Source": {
        "Type": "Engine",
        "Engine": {"Engine": "PCMiler", "ProfileId": "e44fb4d4-f44f-405c-a3fd-f1eba9ece6c3", "ProfileName": "Default"},
        "SourcedFrom": "TenantDefault"
      },
      "NeedsUpdating": false
    },
    "LoadVolume": null,
    "LoadWeight": null,
    "CustomerLinehaul": {
      "Rate": 3000,
      "Units": 1,
      "Amount": 3000,
      "LoadUnits": 1,
      "LoadAmount": 3000,
      "TypeOfMeasure": "Flat",
      "DistanceUom": null,
      "WeightUom": null,
      "VolumeUom": null,
      "MinimumApplied": null
    },
    "Template": {"Id": "495a875d-bffa-4ead-8be8-23c01c6f5fa5", "Name": "Autoport"},
    "References": [],
    "CustomerServiceRepId": null,
    "CustomerServiceRepName": null,
    "CustomerSalesAgentId": "",
    "CustomerSalesAgentName": null,
    "CustomerSalesManagerId": null,
    "CustomerSalesManagerName": null,
    "CustomerLoadPlannerId": null,
    "CustomerLoadPlannerName": null
  },
  "Trip": {
    "id": "1af0526153d442e2b39f31d05af38577",
    "CompanyCode": "CL358",
    "ETag": "\u00228002374b-0000-0300-0000-673ccb260000\u0022",
    "Timestamp": "2024-11-19T17:30:14+00:00",
    "LoadNumber": "1002829",
    "TripNumber": "1002829",
    "OwnerOperatorPaid": false,
    "OwnerOperatorPaystubId": null,
    "Stops": [
      {
        "StopId": "b7d3ef4c8c8046aeb27594fd67aedd2a",
        "CompanyId": "299245054bed47ff8e8c3cc08f77ccda",
        "CompanyShippingHours": null,
        "References": [],
        "Commodities": [],
        "StopType": "Pickup",
        "LoadingType": "Live",
        "Instructions": "",
        "GenInstructions": "",
        "Status": "Covered",
        "Notes": [],
        "StopNotes": [],
        "Appointment": "10:00",
        "StopDate": "11/26/2024",
        "Arrival": null,
        "Departure": null,
        "RequestDetention": null,
        "TimeRecord": {
          "Driver": {"In": null, "Out": null},
          "Truck": {"In": null, "Out": null}
        },
        "StopAddress": {
          "Street": "1 Jackson Dr",
          "ApartmentNumber": "",
          "City": "Jackson Township",
          "Zip": "08527",
          "State": "NJ",
          "Country": "US",
          "Phone": ["9047510700"],
          "Email": [],
          "Website": "",
          "Coordinates": {"Latitude": "40.1091778", "Longitude": "-74.3578076"}
        },
        "OdometerReading": 0,
        "OdometerReadingTime": null,
        "DDT": null,
        "DDTDate": "",
        "DDTTime": "",
        "AppointmentConfirmed": false,
        "ArrivalDateTime": null,
        "DepartureDateTime": null,
        "StopDateTime": "2024-11-26T10:00:00+00:00",
        "LocationOpenTime": null,
        "LocationCloseTime": null,
        "ETA": {
          "LocalDate": "2024-11-26T10:00:00Z",
          "UtcDate": "2024-11-26T15:00:00Z",
          "OffsetMinutes": -300,
          "TimeZoneId": "Eastern Standard Time"
        },
        "Arrived": null,
        "DetentionStarted": null,
        "Departed": null,
        "ScheduleType": "APPT",
        "AppointmentMethod": null,
        "AppointmentLink": null,
        "AppointmentRequested": false,
        "AppointmentDate": {
          "LocalDate": "2024-11-26T10:00:00Z",
          "UtcDate": "2024-11-26T15:00:00Z",
          "OffsetMinutes": -300,
          "TimeZoneId": "Eastern Standard Time"
        },
        "StopWindowBegin": null,
        "StopWindowEnd": null
      },
      {
        "StopId": "0efe73dc519f4fa0bc939345a679147e",
        "CompanyId": "b49f370d2be147d68b96f57013405a9a",
        "CompanyShippingHours": null,
        "References": [],
        "Commodities": [],
        "StopType": "Delivery",
        "LoadingType": "Live",
        "Instructions": "",
        "GenInstructions": "",
        "Status": "Covered",
        "Notes": [],
        "StopNotes": [],
        "Appointment": "14:00",
        "StopDate": "11/29/2024",
        "Arrival": null,
        "Departure": null,
        "RequestDetention": null,
        "TimeRecord": {
          "Driver": {"In": null, "Out": null},
          "Truck": {"In": null, "Out": null}
        },
        "StopAddress": {
          "Street": "245 Park Ave",
          "ApartmentNumber": "",
          "City": "New York",
          "Zip": "10029",
          "State": "NY",
          "Country": "US",
          "Phone": [],
          "Email": ["cypress@cypress.com"],
          "Website": "",
          "Coordinates": {"Latitude": "40.7545475", "Longitude": "-73.9745088"}
        },
        "OdometerReading": 0,
        "OdometerReadingTime": null,
        "DDT": null,
        "DDTDate": "",
        "DDTTime": "",
        "AppointmentConfirmed": false,
        "ArrivalDateTime": null,
        "DepartureDateTime": null,
        "StopDateTime": "2024-11-29T14:00:00+00:00",
        "LocationOpenTime": null,
        "LocationCloseTime": null,
        "ETA": {
          "LocalDate": "2024-11-29T14:00:00Z",
          "UtcDate": "2024-11-29T19:00:00Z",
          "OffsetMinutes": -300,
          "TimeZoneId": "Eastern Standard Time"
        },
        "Arrived": null,
        "DetentionStarted": null,
        "Departed": null,
        "ScheduleType": "APPT",
        "AppointmentMethod": null,
        "AppointmentLink": null,
        "AppointmentRequested": false,
        "AppointmentDate": {
          "LocalDate": "2024-11-29T14:00:00Z",
          "UtcDate": "2024-11-29T19:00:00Z",
          "OffsetMinutes": -300,
          "TimeZoneId": "Eastern Standard Time"
        },
        "StopWindowBegin": null,
        "StopWindowEnd": null
      }
    ],
    "InterestedCarriers": [],
    "CarrierContact": null,
    "CarrierId": "6f83616c-abcc-4b5b-8097-ee9a96a3d72c",
    "DateCarrierAssigned": "2024-11-19T17:30:44.227+00:00",
    "DispatcherPaid": false,
    "EquipmentType": "Reefer",
    "EquipmentLength": "33\u0027",
    "Equipment": "Reefer-33\u0027",
    "Temperature": 34,
    "TemperatureMax": 37,
    "Continuous": false,
    "Hazmat": null,
    "TotalWeight": null,
    "TotalMiles": 88,
    "DispatchMileageSource": {
      "Type": "Engine",
      "Engine": {"Engine": "PCMiler", "ProfileId": "e44fb4d4-f44f-405c-a3fd-f1eba9ece6c3", "ProfileName": "Default"},
      "SourcedFrom": "TenantDefault"
    },
    "DispatchMileageNeedsUpdating": false,
    "ActualMiles": null,
    "PaidMiles": 88,
    "EstimatedEmptyMiles": 2957,
    "ActualEmptyMiles": null,
    "PaidEmptyMiles": 2957,
    "HoursWorked": 0,
    "DatePickedUp": null,
    "DateDelivered": null,
    "PickupDate": "2024-11-26T10:00:00+00:00",
    "DeliveryDate": "2024-11-29T14:00:00+00:00",
    "DateReleased": null,
    "DateTonu": null,
    "Status": "Dispatched",
    "PreviousStatus": null,
    "CarrierRate": 3000,
    "TripValue": 3000,
    "OORatePreCommission": 3000,
    "OwnerOperatorId": "DR2517038670011412149",
    "TruckId": "TR2517907601975866974",
    "TrailerId": "TL2517907601601886384",
    "Driver1Id": "DR2517038670011412149",
    "Driver1ContractorType": "Owner Operator",
    "Driver2Id": null,
    "Driver1FleetId": "80200ea01c214da19142ec76463f91c2",
    "Driver1FleetName": "autoport north",
    "Driver2FleetId": null,
    "Driver2FleetName": null,
    "TruckFleetId": "80200ea01c214da19142ec76463f91c2",
    "TruckFleetName": "autoport n14",
    "TrailerFleetId": "cfdcde9aae8e4d099215d6242384179c",
    "TrailerFleetName": "autoport south",
    "Driver2ContractorType": null,
    "Driver1Rates": [],
    "Driver2Rates": [],
    "OwnerOperatorRates": [],
    "OwnerOperatorFees": [],
    "Driver1Paid": false,
    "Driver2Paid": false,
    "PreviousTripNumber": "1002793",
    "PreviousLocation": {
      "Name": "",
      "GoogleId": "",
      "Street": "1 Apple Park Way",
      "ApartmentNumber": "",
      "City": "Cupertino",
      "Zip": "95014",
      "State": "CA",
      "Country": "",
      "Phone": [],
      "PhoneExtension": "",
      "Email": [],
      "Fax": "",
      "Contacts": [],
      "Website": "",
      "Coordinates": {"Latitude": "37.32974", "Longitude": "-122.00708"},
      "CoordinatesFound": true,
      "VerifiedCoordinates": null,
      "CheckedWithNtk": null
    },
    "DriverStatus": "Online",
    "Driver2Status": null,
    "DispatchedBy": "14445c06-698e-4859-83b3-2dc960a8c50b",
    "DispatchedByName": "Automations User - DO NOT DELETE",
    "ReleasedBy": null,
    "DispatchedOnBehalfOf": "ee2c704f-2091-4052-a268-4fa762f38556",
    "DispatchedOnBehalfOfName": "Alvys Support - Jaymar",
    "DispatcherName": "Automations User - DO NOT DELETE",
    "TenderAs": "AUTOPORT LLC",
    "IsDeleted": false,
    "IsVisible": true,
    "OriginalTripId": null,
    "Messages": [],
    "IsEnabledFourKitesSharing": null,
    "IsEnabledEdiHeartbeat": null,
    "IsEnabledP44Sharing": null,
    "IsEDIShareable": false,
    "VisibilitySettings": {"Enabled": false, "EdiShareable": false, "IsVisible": true},
    "CarrierSalesAgentId": null,
    "CarrierSalesAgentName": null,
    "QuickPay": false,
    "TripType": "Carrier",
    "IsPaid": false,
    "Driver1PayStubId": null,
    "Driver2PayStubId": null,
    "LastCheckCall": null,
    "CarrierPayments": [],
    "DueDate": null,
    "CarrierPayOnHold": null,
    "CarrierInvoiceNumber": null,
    "BrokerageStatus": null,
    "BrokerageStatusDescription": null
  },
  "LoadCustomer": {
    "id": "749ed780-bc20-40c4-8871-a965353196d3",
    "CompanyNumber": "ANH23FOCO80524",
    "Name": "Anheuser Busch",
    "OPSTeamEmail": "",
    "QuickBooksName": "Anheuser-Busch",
    "ShippingHours": "",
    "GeneralInstructions": "\u003Cp\u003EThis a general instruction!\u003C/p\u003E",
    "Status": "Active",
    "Type": "Customer",
    "PaymentType": "",
    "MCNum": "",
    "TermsInDays": null,
    "SendNotification": false,
    "IsDeleted": false,
    "DateCreated": "2022-03-25T19:13:44.111+00:00",
    "PhysicalAddress": {
      "Street": "2351 Busch Dr",
      "ApartmentNumber": "",
      "City": "Fort Collins",
      "Zip": "80524",
      "State": "CO",
      "Country": "US",
      "Phone": ["1111111111"],
      "Email": [],
      "Website": "",
      "Coordinates": {"Latitude": "40.6204692", "Longitude": "-105.0093839"}
    },
    "NewBillingAddress": {
      "Street": "2351 Busch Dr",
      "ApartmentNumber": "",
      "City": "Fort Collins",
      "Zip": "80524",
      "State": "CO",
      "Country": "",
      "Phone": [],
      "Email": ["developers@alvys.com"],
      "Website": "",
      "Coordinates": {"Latitude": "40.617477", "Longitude": "-105.0051165"}
    },
    "InvoicingInformation": {
      "Address": {
        "Street": "2351 Busch Dr",
        "City": "Fort Collins",
        "State": "CO",
        "Zip": "80524",
        "Country": "USA",
        "ApartmentNumber": null,
        "FullStateName": null,
        "Coordinates": {"Latitude": "40.617477", "Longitude": "-105.00512"}
      },
      "EmailAddresses": ["developers@alvys.com"],
      "InvoicingName": "Anheuser-Busch",
      "PhoneNumber": null,
      "FaxNumber": null,
      "AccountManagerEmail": null,
      "InvoicingNameAlias": "Anheuser-Busch",
      "PaymentType": null,
      "PaymentTermsInDays": null
    },
    "Notes": [],
    "CreditCheckStatus": [
      {
        "FactoringCompany": "SaintJohnCapital",
        "SubsidiaryId": "14c9564f-8425-3df7-e4af-f46e24a64fc0",
        "Status": "Approved",
        "Message": "ANHEUSER BUSCH COS INC is approved",
        "LastUpdated": "2023-12-11T16:01:39.477+00:00"
      }
    ],
    "InvoicingSettings": [
      {
        "Subsidiary": "Alvys Brokerage",
        "Setting": {
          "Mode": "Individual",
          "UpdateMode": "Amendment",
          "RequiredDocumentsLoadStatus": null,
          "Methods": ["Factoring Company"],
          "RequiredDocuments": ["Invoice", "Proof of Delivery"],
          "AutoMergeDocuments": []
        },
        "ReferenceNumber": ""
      }
    ],
    "BrokerId": null
  },
  "InvoiceSettings": {
    "Subsidiary": "AUTOPORT LLC",
    "Mode": "Individual",
    "RequiredDocumentsLoadStatus": "Invoiced",
    "UpdateMode": "Amendment",
    "Methods": ["Email"],
    "RequiredDocuments": ["Proof of Delivery", "Customer Rate Confirmation"],
    "AutoMergeDocuments": ["Proof of Delivery", "Customer Rate Confirmation"],
    "ReferenceNumber": null
  },
  "TripCarrier": {
    "id": "6f83616c-abcc-4b5b-8097-ee9a96a3d72c",
    "Name": "AUTOPORT LLC",
    "QuickBooksName": "",
    "EditSequence": "",
    "ListId": "",
    "Address": {
      "Street": "1922 B BUCK LN",
      "ApartmentNumber": "",
      "City": "ALBANY",
      "Zip": "31707",
      "State": "GA",
      "Country": "",
      "Phone": ["(678) 429-8937"],
      "Email": ["AUTOPORTOFGA@GMAIL.COM"],
      "Website": "",
      "Coordinates": null
    },
    "MCNum": "17394",
    "USDOTNum": "2987570",
    "FactoringCompanyID": "",
    "PaymentMethod": null,
    "PaymentType": "",
    "OOPercentage": null,
    "CarrierType": "Subsidiary",
    "Status": "",
    "IsVerified": false,
    "DefaultCarrier": true,
    "Source": null
  },
  "CarrierFactoringCompany": null,
  "OwnerOperator": {
    "id": "DR2517038670011412149",
    "ParentId": null,
    "Name": "Kevin Operator Dr",
    "Address": {
      "Street": "1 Cypress Knee Trail",
      "ApartmentNumber": "",
      "City": "Kitty Hawk",
      "Zip": "27949",
      "State": "NC",
      "Country": "",
      "Phone": [],
      "Email": [],
      "Website": "",
      "Coordinates": {"Latitude": "36.0939868", "Longitude": "-75.71876619999999"}
    },
    "Email": "kcalvin@outlook.com",
    "Phone": "8762823478",
    "ContractorType": "Owner Operator",
    "LicenseNum": "LC09",
    "Rates": [
      {"Rate": 70, "ExtraStops": null, "RateType": "Percentage", "PerDiemRateType": "", "FreeUnit": 0, "Source": null}
    ],
    "Fees": [],
    "CompanyOwnedAsset": true,
    "CompanyCode": "CL358",
    "ActiveAsset": true,
    "CompanyName": "Kevin Operator",
    "Subsidiary": "262d5144-b873-4971-80c9-e83a94309ad8",
    "CompanyAddress": {
      "Street": "1 Cypress Avenue",
      "ApartmentNumber": "",
      "City": "Los Angeles",
      "Zip": "90095",
      "State": "CA",
      "Country": "",
      "Phone": [],
      "Email": [],
      "Website": "",
      "Coordinates": null
    },
    "CompanyEmail": "kcalvin@outlook.com",
    "CompanyPhone": "8762823478",
    "QuickBooksName": "",
    "IsADriver": true,
    "AccessorialFees": [
      {"FeeType": "Escort", "Percentage": 1}
    ],
    "DeductFuel": true,
    "ApplyFuelDiscount": false
  },
  "TripTruck": {
    "id": "TR2517907601975866974",
    "ParentId": "DR2517038670011412149",
    "ParentType": "Owner Operator",
    "TruckNum": "TRK104",
    "Year": 2019,
    "Make": "Volvo",
    "Model": "",
    "LicenseNum": "",
    "LicenseState": "",
    "VINNum": "",
    "CompanyOwnedAsset": true,
    "CompanyCode": "CL358",
    "Subsidiary": "262d5144-b873-4971-80c9-e83a94309ad8",
    "ActiveAsset": true,
    "EldProviders": [],
    "DeductFuel": null,
    "ApplyFuelDiscount": null,
    "DeductToll": false,
    "Status": "Active"
  },
  "TripTrailer": {
    "id": "TL2517907601601886384",
    "ParentId": "6f83616c-abcc-4b5b-8097-ee9a96a3d72c",
    "ParentType": "",
    "TrailerNum": "TRR104",
    "Year": 2023,
    "Make": "Utility",
    "LicenseNum": "",
    "LicenseState": "",
    "VINNum": "",
    "EquipmentType": "Reefer",
    "EquipmentSize": "53\u0027",
    "CompanyOwnedAsset": true,
    "CompanyCode": "CL358",
    "Subsidiary": "262d5144-b873-4971-80c9-e83a94309ad8",
    "ActiveAsset": true,
    "EldProviders": [
      {"id": "87500E", "DatagateWayId": "", "IntegrationType": "Lynx", "DeviceType": null}
    ],
    "DeductFuel": null,
    "ApplyFuelDiscount": null,
    "Status": null
  },
  "LoadOffice": {
    "id": "cca5b831-adba-4f85-ada9-10a4912a23b2",
    "Name": "Calvin Logistics",
    "SharedWith": {"Users": [], "Groups": []}
  },
  "LoadUsers": [
    {
      "id": "14445c06-698e-4859-83b3-2dc960a8c50b",
      "UserName": "developers@alvys.com",
      "Name": "Automations User - DO NOT DELETE"
    },
    {
      "id": "ee2c704f-2091-4052-a268-4fa762f38556",
      "UserName": "jaymar.henry@alvys.com",
      "Name": "Alvys Support - Jaymar"
    }
  ],
  "Attachments": [],
  "Invoices": [],
  "TripCompanies": [
    {
      "id": "299245054bed47ff8e8c3cc08f77ccda",
      "CompanyNumber": "STOBUJAFL32218",
      "Name": "Stop 1",
      "Type": "Shipper/Consignee",
      "IsDeleted": false,
      "DateCreated": "2023-04-17T18:59:20.123+00:00",
      "MCNum": "",
      "PhysicalAddress": {
        "Street": "1 Jackson Dr",
        "ApartmentNumber": "",
        "City": "Jackson Township",
        "Zip": "08527",
        "State": "NJ",
        "Country": "US",
        "Phone": ["9047510700"],
        "Email": [],
        "Website": "",
        "Coordinates": {"Latitude": "40.1091778", "Longitude": "-74.3578076"}
      },
      "SendNotification": false,
      "ShippingHours": "",
      "GeneralInstructions": "",
      "Notes": [
        {
          "id": "89ee4546-bbcc-4251-8e2a-9aa4ba88dc9a",
          "Description": "Test Company",
          "NoteType": "General",
          "Time": "2023-04-17T18:59:45.769+00:00",
          "User": "Kevin Calvin"
        }
      ]
    },
    {
      "id": "b49f370d2be147d68b96f57013405a9a",
      "CompanyNumber": "STO92TEAZ85284",
      "Name": "Stop 2",
      "Type": "Shipper/Consignee",
      "IsDeleted": false,
      "DateCreated": "2023-04-17T19:01:05.806+00:00",
      "MCNum": "",
      "PhysicalAddress": {
        "Street": "245 Park Ave",
        "ApartmentNumber": "",
        "City": "New York",
        "Zip": "10029",
        "State": "NY",
        "Country": "US",
        "Phone": [],
        "Email": ["cypress@cypress.com"],
        "Website": "",
        "Coordinates": {"Latitude": "40.7545475", "Longitude": "-73.9745088"}
      },
      "SendNotification": false,
      "ShippingHours": "",
      "GeneralInstructions": "",
      "Notes": []
    }
  ],
  "TripDrivers": [
    {
      "id": "DR2517038670011412149",
      "ParentId": null,
      "Name": "Kevin Operator Dr",
      "Address": {
        "Street": "1 Cypress Knee Trail",
        "ApartmentNumber": "",
        "City": "Kitty Hawk",
        "Zip": "27949",
        "State": "NC",
        "Country": "",
        "Phone": [],
        "Email": [],
        "Website": "",
        "Coordinates": {"Latitude": "36.0939868", "Longitude": "-75.71876619999999"}
      },
      "Email": "kcalvin@outlook.com",
      "Phone": "8762823478",
      "ContractorType": "Owner Operator",
      "LicenseNum": "LC09",
      "Rates": [
        {"Rate": 70, "ExtraStops": null, "RateType": "Percentage", "PerDiemRateType": "", "FreeUnit": 0, "Source": null}
      ],
      "Fees": [],
      "CompanyOwnedAsset": true,
      "CompanyCode": "CL358",
      "ActiveAsset": true,
      "CompanyName": "Kevin Operator",
      "Subsidiary": "262d5144-b873-4971-80c9-e83a94309ad8",
      "CompanyAddress": {
        "Street": "1 Cypress Avenue",
        "ApartmentNumber": "",
        "City": "Los Angeles",
        "Zip": "90095",
        "State": "CA",
        "Country": "",
        "Phone": [],
        "Email": [],
        "Website": "",
        "Coordinates": null
      },
      "CompanyEmail": "kcalvin@outlook.com",
      "CompanyPhone": "8762823478",
      "QuickBooksName": "",
      "IsADriver": true,
      "AccessorialFees": [
        {"FeeType": "Escort", "Percentage": 1}
      ],
      "DeductFuel": true,
      "ApplyFuelDiscount": false
    }
  ],
  "Location": [
    {
      "TripId": "094049957435478492006955eda32e06",
      "Source": "Lynx",
      "InternalAssetId": "TL2517907601601886384",
      "AssetType": "Trailer",
      "ControlMode": "Start/Stop",
      "Power": "On",
      "FormattedAddress": "102 Williams Dr, Texas, Comanche, United States, 76442",
      "NextStopAddress": "1 Jackson Dr Jackson Township NJ 08527",
      "NextStopDate": "11/25/2024",
      "NextStopAppointment": "10:01",
      "NextStopETA": 105540,
      "ProbeTemperature1": null,
      "SetpointTemperatureZone1": 65,
      "SupplyAirTemperature1": 65,
      "ReturnAirTemperature1": null,
      "AmbientTemperature": 75,
      "HosAdjusted": false,
      "Latitude": 31.89738,
      "Longitude": -98.61403,
      "DateCreated": "2024-11-19T17:30:27.276+00:00",
      "LastModified": "2024-11-19T17:22:52+00:00",
      "FuelPercent": 100,
      "LastCity": "Comanche",
      "LastCountry": "US",
      "LastStreet": "901 W Central Ave",
      "LastZip": "76442",
      "LastState": "TX",
      "DateCreatedLocalTime": "2024-11-19T11:30:27.276-06:00",
      "NextStopDateTime": "2024-11-25T10:01:00\u002B00:00",
      "Temperature": 65
    },
    {
      "TripId": "3d3ef4e36884474ba98c9597624a6ba7",
      "Source": "App",
      "InternalAssetId": "DR2517038670011412149",
      "AssetType": "Driver",
      "ControlMode": null,
      "Power": null,
      "FormattedAddress": "Seaton Crescent Sda Church, Westmoreland, Jamaica",
      "NextStopAddress": "245 Park Ave New York NY 10029",
      "NextStopDate": "10/21/2024",
      "NextStopAppointment": "15:00",
      "NextStopETA": null,
      "ProbeTemperature1": null,
      "SetpointTemperatureZone1": null,
      "SupplyAirTemperature1": null,
      "ReturnAirTemperature1": null,
      "AmbientTemperature": null,
      "HosAdjusted": false,
      "Latitude": 18.218173870588785,
      "Longitude": -78.13879328781343,
      "DateCreated": "2024-11-13T19:28:04.535+00:00",
      "LastModified": "2024-11-13T19:28:04.388+00:00",
      "FuelPercent": null,
      "LastCity": "Westmoreland",
      "LastCountry": "JAM",
      "LastStreet": null,
      "LastZip": null,
      "LastState": null,
      "DateCreatedLocalTime": "2024-11-13T14:28:04.535-05:00",
      "NextStopDateTime": "2024-10-21T15:00:00\u002B00:00",
      "Temperature": null
    },
    {
      "TripId": "45407d44d3564b85ae1564484e23a7b7",
      "Source": "CheckCall",
      "InternalAssetId": "DR2517038670011412149",
      "AssetType": "Dispatch",
      "ControlMode": null,
      "Power": null,
      "FormattedAddress": "1 Apple Park Way Cupertino CA 95014",
      "NextStopAddress": "1 Jackson Dr Jackson Township NJ 08527",
      "NextStopDate": "11/28/2024",
      "NextStopAppointment": "10:08",
      "NextStopETA": 183360,
      "ProbeTemperature1": null,
      "SetpointTemperatureZone1": null,
      "SupplyAirTemperature1": null,
      "ReturnAirTemperature1": null,
      "AmbientTemperature": null,
      "HosAdjusted": false,
      "Latitude": 37.32974,
      "Longitude": -122.00708,
      "DateCreated": "2024-11-15T20:56:18.483+00:00",
      "LastModified": "2024-11-15T20:56:18.483+00:00",
      "FuelPercent": null,
      "LastCity": "Cupertino",
      "LastCountry": "USA",
      "LastStreet": "Apple Park Way",
      "LastZip": "95014-0642",
      "LastState": "CA",
      "DateCreatedLocalTime": "2024-11-15T12:56:18.483-08:00",
      "NextStopDateTime": "2024-11-28T10:08:00\u002B00:00",
      "Temperature": null
    },
    {
      "TripId": "3d3ef4e36884474ba98c9597624a6ba7",
      "Source": "App",
      "InternalAssetId": "DR2517038670011412149",
      "AssetType": "Driver",
      "ControlMode": null,
      "Power": null,
      "FormattedAddress": "Seaton Crescent Sda Church, Westmoreland, Jamaica",
      "NextStopAddress": "245 Park Ave New York NY 10029",
      "NextStopDate": "10/21/2024",
      "NextStopAppointment": "15:00",
      "NextStopETA": null,
      "ProbeTemperature1": null,
      "SetpointTemperatureZone1": null,
      "SupplyAirTemperature1": null,
      "ReturnAirTemperature1": null,
      "AmbientTemperature": null,
      "HosAdjusted": false,
      "Latitude": 18.218173870588785,
      "Longitude": -78.13879328781343,
      "DateCreated": "2024-11-13T19:28:04.535+00:00",
      "LastModified": "2024-11-13T19:28:04.388+00:00",
      "FuelPercent": null,
      "LastCity": "Westmoreland",
      "LastCountry": "JAM",
      "LastStreet": null,
      "LastZip": null,
      "LastState": null,
      "DateCreatedLocalTime": "2024-11-13T14:28:04.535-05:00",
      "NextStopDateTime": "2024-10-21T15:00:00\u002B00:00",
      "Temperature": null
    },
    {
      "TripId": "45407d44d3564b85ae1564484e23a7b7",
      "Source": "CheckCall",
      "InternalAssetId": "DR2517038670011412149",
      "AssetType": "Dispatch",
      "ControlMode": null,
      "Power": null,
      "FormattedAddress": "1 Apple Park Way Cupertino CA 95014",
      "NextStopAddress": "1 Jackson Dr Jackson Township NJ 08527",
      "NextStopDate": "11/28/2024",
      "NextStopAppointment": "10:08",
      "NextStopETA": 183360,
      "ProbeTemperature1": null,
      "SetpointTemperatureZone1": null,
      "SupplyAirTemperature1": null,
      "ReturnAirTemperature1": null,
      "AmbientTemperature": null,
      "HosAdjusted": false,
      "Latitude": 37.32974,
      "Longitude": -122.00708,
      "DateCreated": "2024-11-15T20:56:18.483+00:00",
      "LastModified": "2024-11-15T20:56:18.483+00:00",
      "FuelPercent": null,
      "LastCity": "Cupertino",
      "LastCountry": "USA",
      "LastStreet": "Apple Park Way",
      "LastZip": "95014-0642",
      "LastState": "CA",
      "DateCreatedLocalTime": "2024-11-15T12:56:18.483-08:00",
      "NextStopDateTime": "2024-11-28T10:08:00\u002B00:00",
      "Temperature": null
    }
  ],
  "DriverHOS": [],
  "LoadBoards": [],
  "ReasonPreventingInvoicing":
      "The following required invoicing document(s) are missing: Proof of Delivery, Customer Rate Confirmation, Load status \u0027Dispatched\u0027 is not eligible for invoicing",
  "FirstPickStopStatus": "Covered",
  "LastDropStopStatus": "Covered",
  "FirstStop": "Stop 1",
  "LastStop": "Stop 2",
  "BillableAmount": 3000,
  "CustomerLineHaul": 3000,
  "CustomerFuelSurcharge": null,
  "FactoringPayments": 0,
  "FactoringFee": 0,
  "FactoringEscrow": 0,
  "CarrierDetention": 0,
  "CarrierLumper": 0,
  "CarrierLateFee": 0,
  "CarrierOtherAcc": 0,
  "CarrierAdvances": 0,
  "CustomerDetention": 0,
  "CustomerLumper": 0,
  "CustomerLateFee": 0,
  "CustomerOtherAcc": 0,
  "CustomerPaymentsTotal": 0,
  "CustomerPaymentDate": null,
  "SalesDifference": 0,
  "SalesMargin": 0,
  "RatePerMile": 34.09090909090909,
  "CommissionableAmount": 3000,
  "DispatchCommissionable": 3000,
  "DriverRate": 2100,
  "LastLocation": null,
  "LastLocationNextStop": null,
  "LastLocationUpdate": null,
  "LastLocationNextStopEta": null,
  "LastLocationNextStopAppointment": null,
  "DeliveryDate": "2024-11-29T14:00:00+00:00",
  "DropAppointment": "14:00",
  "PickupDate": "2024-11-26T10:00:00+00:00",
  "PickAppointment": "10:00"
};
