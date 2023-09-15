import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/exceptions.dart';
import '../../../../utils/extensions.dart';
import '../../../authentication/presentation/auth_provider_controller.dart';
import '../../../trips/presentation/controller/trip_page_controller.dart';
import '../../data/echeck_repository.dart';
import '../../domain/echeck_state/echeck_state.dart';
import '../../domain/generate_echeck/generate_echeck_request.dart';

class EcheckPageController extends AsyncNotifier<ECheckState> implements IAppErrorHandler {
  late TripController tripController;
  late EcheckRepository repo;
  late AuthProviderNotifier auth;

  //   'Late Fee',
  //   'Extra Labor Delivery',
  //   'Lumper',
  // ];

  @override
  FutureOr<ECheckState> build() {
    tripController = ref.read(tripControllerProvider.notifier);
    repo = ref.read(eCheckRepoProvider);
    auth = ref.read(authProvider.notifier);
    return ECheckState();
  }

  List<DropdownMenuItem<String>> get reasonsDropdown => state.value!.reasons
      .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ))
      .toList();

  void setReason(String? val) {
    print(val);
    print(state.value!.reason);
    state = AsyncData(state.value!.copyWith(reason: val));
    print(state.value!.reason);
    if (!state.value!.showStopDropdown) {
      setStopId(null);
    }
  }

  void setStopId(String? stopId) {
    state = AsyncValue.data(state.value!.copyWith(stopId: stopId));
  }

  void setAmount(String? amount) {
    state = AsyncValue.data(state.value!.copyWith(amount: double.tryParse(amount.currencyNumbersOnly) ?? 0));
    print(state.value!.amount);
  }

  void setNote(String? note) {
    state = AsyncValue.data(state.value!.copyWith(note: note ?? ''));
  }

  String? validDouble(String? val) {
    if (double.tryParse(val.currencyNumbersOnly) == null) {
      return 'Enter a valid currency value';
    }
    return null;
  }

  Future<void> generateEcheck(GlobalKey<FormState> formKey, BuildContext context, String tripId) async {
    if (formKey.currentState?.validate() ?? false) {
      state = const AsyncLoading();
      var firstName = auth.driver!.name!.split('').first;
      var lastName = auth.driver!.name!.split('').elementAtOrNull(1) ?? '';
      var trip = tripController.getTrip(tripId)!;
      var req = GenerateECheckRequest(
          tripId: trip.id!,
          reason: state.value!.reason!,
          note: state.value!.note,
          firstName: firstName,
          lastName: lastName,
          driverId: trip.driver1Id!,
          amount: state.value!.amount);
      var res = await repo.generateEcheck<EcheckPageController>(trip.companyCode!, req);
      tripController.addEcheck(trip.id!, res);
      state = AsyncData(state.value!);
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  Future<void> cancelEcheck(String tripId, String echeckNumber) async {
    state = AsyncData(state.value!.copyWith(loadingEcheckNumber: echeckNumber));
    var trip = tripController.getTrip(tripId);
    if (trip == null) {
      state = AsyncData(state.value!.copyWith(loadingEcheckNumber: null));
      return;
    }
    var res = await repo.cancelEcheck(trip.companyCode!, echeckNumber);
    tripController.updateEcheck(tripId, res);
    state = AsyncData(state.value!.copyWith(loadingEcheckNumber: null));
  }

  @override
  FutureOr<void> onError() {
    state = AsyncData(state.value!.copyWith(loadingEcheckNumber: null));
  }
}

final echeckPageControllerProvider = AsyncNotifierProvider<EcheckPageController, ECheckState>(EcheckPageController.new);
