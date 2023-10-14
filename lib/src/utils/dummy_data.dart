import 'package:intl/intl.dart';

import '../features/documents/domain/app_document/app_document.dart';
import '../features/trips/domain/app_trip/app_trip.dart';
import '../features/trips/domain/app_trip/echeck.dart';
import '../features/trips/domain/app_trip/payable_driver.dart';
import '../features/trips/domain/app_trip/record.dart';
import '../features/trips/domain/app_trip/stop.dart';
import '../features/trips/domain/app_trip/time_record.dart';
import '../models/address/address.dart';
import 'magic_strings.dart';

final AppTrip testTrip = AppTrip(
  id: 'testtripid45',
  orderNumber: 'test order',
  loadId: 'testloadid45',
  dispatch: '',
  companyCode: 'TS500',
  attachments: [
    AppDocument(
        companyCode: 'TS500',
        documentPath: '',
        companyName: 'Test company',
        documentType: 'Test document',
        date: DateTime.now().subtract(const Duration(hours: 15)))
  ],
  continuous: true,
  deliveryDate: DateTime.now().add(const Duration(days: 10)),
  dispatchEmail: '',
  dispatchPhone: '',
  dispatcherId: '',
  driver1Id: 'DR342352543123',
  driver2Id: null,
  driver1Paid: false,
  driver2Paid: false,
  drivers: ['DR342352543123'],
  eChecks: [
    ECheck(
        amount: 10,
        amountUsed: 5,
        eCheckId: 'asda23244533232',
        expressCheckNumber: '43567424522',
        reason: 'Lumpar',
        isCanceled: false,
        dateGenerated: DateTime.now().subtract(const Duration(days: 2)))
  ],
  emptyMiles: 325,
  equipment: 'Lumber',
  equipmentLength: '12',
  firstStopAddress: '345 Test Blvd Test Town, CA, 3241',
  lastStopAddress: '34 Test Ave Testville, VA, 4425',
  generalInstructions: '',
  isOop: false,
  isTripActive: true,
  loadNumber: '1000254',
  tripNumber: '1000254-1',
  loadRate: 432,
  loadType: '',
  paidMiles: 323,
  payableDriverAmounts: [const PayableDriverAmount(id: 'DR342352543123', amount: 20)],
  pickupDate: DateTime.now().add(const Duration(days: 3)),
  rate: 100,
  status: TripStatus.inTransit,
  stopCount: 2,
  stops: [
    Stop(
      comodities: [],
      companyName: 'Test company 1',
      actualStopdate: DateTime.now().add(const Duration(days: 3)),
      address: Address(street: '345 Test Blvd', city: 'Test Town', zip: '3241', state: 'CA'),
      appointment: DateFormat(DateFormat.HOUR_MINUTE).format(DateTime.now().add(const Duration(days: 3))),
      stopAddress: '345 Test Blvd Test Town, CA, 3241',
      stopDate: DateTime.now().add(const Duration(days: 3)),
      genInstructions: 'Get here on time',
      timeRecord: TimeRecord(
        driver: Record(),
      ),
      references: [],
      instructions: '',
      stopId: 'erasfdfsd2345432',
      latitude: '0',
      longitude: '0',
      notes: [],
      phone: '',
      status: 'Covered',
      stopType: 'Pickup',
    ),
    Stop(
      comodities: [],
      companyName: 'Test company 2',
      actualStopdate: DateTime.now().add(const Duration(days: 10)),
      address: Address(street: '34 Test Ave', city: 'Testville', zip: '4425', state: 'VA'),
      appointment: DateFormat(DateFormat.HOUR_MINUTE).format(DateTime.now().add(const Duration(days: 10))),
      stopAddress: '34 Test Ave Testville, VA, 4425',
      stopDate: DateTime.now().add(const Duration(days: 10)),
      genInstructions: 'Get here on time',
      timeRecord: TimeRecord(
        driver: Record(),
      ),
      references: [],
      instructions: '',
      stopId: 'erasfdfsd2345432',
      latitude: '0',
      longitude: '0',
      notes: [],
      phone: '',
      status: 'Covered',
      stopType: 'Delivery',
    )
  ],
  temperature: -5,
  totalMiles: 300,
  totalWeight: 200,
  trailerId: 'asdfsgfsfasasddfsfsd',
  trailerNum: '34Low',
  tripValue: 120,
  tripValueDriver: '',
  truckId: 'sadasewq23243ee',
  truckNum: '7738',
);
