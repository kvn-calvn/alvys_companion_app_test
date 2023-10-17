import 'dart:async';

import 'package:alvys3/src/common_widgets/snack_bar.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../../../../network/http_client.dart';
import '../../../../utils/provider_args_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/exceptions.dart';
import '../../../../utils/extensions.dart';
import '../../../authentication/presentation/auth_provider_controller.dart';
import '../../../trips/presentation/controller/trip_page_controller.dart';
import '../../data/echeck_repository.dart';
import '../../domain/echeck_state/echeck_state.dart';
import '../../domain/generate_echeck/generate_echeck_request.dart';

class EcheckPageController extends AutoDisposeFamilyAsyncNotifier<ECheckState, String?> implements IAppErrorHandler {
  late TripController tripController;
  late EcheckRepository repo;
  late AuthProviderNotifier auth;

  //   'Late Fee',
  //   'Extra Labor Delivery',
  //   'Lumper',
  // ];

  @override
  FutureOr<ECheckState> build(String? arg) {
    tripController = ref.read(tripControllerProvider.notifier);
    repo = ref.read(eCheckRepoProvider);
    auth = ref.read(authProvider.notifier);
    ProviderArgsSaver.instance.echeckArgs = arg;
    return ECheckState(stopId: arg);
  }

  List<DropdownMenuItem<String>> get reasonsDropdown => state.value!.reasons
      .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ))
      .toList();

  void setReason(String? val) {
    state = AsyncData(state.value!.copyWith(reason: val));
    if (!state.value!.showStopDropdown) {
      setStopId(null);
    }
  }

  void setStopId(String? stopId) {
    state = AsyncValue.data(state.value!.copyWith(stopId: stopId));
  }

  void setAmount(String? amount) {
    state = AsyncValue.data(state.value!.copyWith(amount: double.tryParse(amount.currencyNumbersOnly) ?? 0));
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
      var firstName = auth.driver!.name!.split(' ').first;
      var lastName = auth.driver!.name!.split(' ').elementAtOrNull(1) ?? '';
      var trip = tripController.getTrip(tripId)!;
      var req = GenerateECheckRequest(
          tripId: trip.id!,
          reason: state.value!.reason!,
          note: state.value!.note,
          firstName: firstName,
          lastName: lastName,
          stopId: state.value!.showStopDropdown ? state.value!.stopId : null,
          driverId: trip.driver1Id!,
          amount: state.value!.amount);
      var res = await repo.generateEcheck<EcheckPageController>(trip.companyCode!, req);
      ref.read(httpClientProvider).telemetryClient.trackEvent(name: "generate_echeck", additionalProperties: {
        "tripId": req.tripId,
        "reason": req.reason,
        "note": req.note,
        "amount": req.amount,
        "stopId": req.stopId ?? "",
        "first_name": req.firstName,
        "last_name": req.lastName
      });
      await FirebaseAnalytics.instance.logEvent(name: "generate_echeck", parameters: <String, String>{
        "tripId": req.tripId,
        "reason": req.reason,
        "note": req.note,
        "amount": req.amount.toString(),
        "stopId": req.stopId.toString(),
        "first_name": req.firstName,
        "last_name": req.lastName
      });

      tripController.addEcheck(trip.id!, res);
      state = AsyncData(state.value!);
      if (context.mounted) {
        resetState();
        Navigator.of(context, rootNavigator: true).pop(res.expressCheckNumber);
      }
    }
  }

  Future<void> cancelEcheck(BuildContext context, String tripId, String echeckNumber) async {
    state = AsyncData(state.value!.copyWith(loadingEcheckNumber: echeckNumber));
    var trip = tripController.getTrip(tripId);

    if (trip == null) {
      state = AsyncData(state.value!.copyWith(loadingEcheckNumber: null));
      return;
    }
    var res = await repo.cancelEcheck<EcheckPageController>(trip.companyCode!, echeckNumber);
    tripController.updateEcheck(tripId, res);
    state = AsyncData(state.value!.copyWith(loadingEcheckNumber: null));
    var snackbar = SnackBarWrapper.getSnackBar('ECheck $echeckNumber has been canceled');
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  FutureOr<void> onError(Exception ex) {
    state = AsyncData(state.value!.copyWith(loadingEcheckNumber: null));
  }

  void resetState() {
    state = AsyncData(ECheckState(stopId: arg));
  }

  @override
  FutureOr<void> refreshPage(String page) {}
}

final echeckPageControllerProvider =
    AutoDisposeAsyncNotifierProviderFamily<EcheckPageController, ECheckState, String?>(EcheckPageController.new);
