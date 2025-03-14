import 'dart:async';

import '../../domain/accessorial_types/accessorial_types.dart';

import '../../../../network/posthog/domain/posthog_objects.dart';
import '../../../../network/posthog/posthog_service.dart';
import '../../../../utils/magic_strings.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';

import '../../../../common_widgets/snack_bar.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../../../../network/http_client.dart';
import '../../../../network/posthog/posthog_provider.dart';
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

class EcheckArgs {
  final String? stopId;

  EcheckArgs(this.stopId);
}

class EcheckPageController extends AutoDisposeFamilyAsyncNotifier<ECheckState, ({String? stopId})>
    implements IErrorHandler {
  late TripController tripController;
  late EcheckRepository repo;
  late AuthProviderNotifier auth;
  late PostHogService postHogService;
  //   'Late Fee',
  //   'Extra Labor Delivery',
  //   'Lumper',
  // ];
  @override
  FutureOr<ECheckState> build(({String? stopId}) arg) {
    debugPrint('build called');
    tripController = ref.read(tripControllerProvider.notifier);
    repo = ref.read(eCheckRepoProvider);
    auth = ref.read(authProvider.notifier);
    postHogService = ref.read(postHogProvider);
    ProviderArgsSaver.instance.echeckArgs = arg;
    return ECheckState(stopId: arg.stopId);
  }

  void setReason(GetAccessorialTypesResponse? val) {
    state = AsyncData(state.value!.copyWith(reason: val));
    if (!state.value!.showStopDropdown) {
      setStopId(null);
    }
  }

  void setStopId(String? stopId) {
    state = AsyncValue.data(state.value!.copyWith(stopId: stopId));
  }

  void setAmount(String? amount) {
    state = AsyncValue.data(
        state.value!.copyWith(amount: double.tryParse(amount.currencyNumbersOnly) ?? 0));
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

  Future<void> generateEcheck(
      GlobalKey<FormState> formKey, BuildContext context, String tripId) async {
    if (formKey.currentState?.validate() ?? false) {
      state = const AsyncLoading();
      var nameList = auth.driver!.name!.split(' ');
      var firstName = nameList.first;
      var lastName = nameList.elementAtOrNull(1) ?? '';
      var trip = tripController.getTrip(tripId)!;
      var stopId = state.value!.showStopDropdown ? state.value!.stopId : null;
      var stop = tripController.getStop(tripId, stopId);
      var req = GenerateECheckRequest(
        tripId: trip.id!,
        typeName: state.value!.reason!.name,
        note: state.value!.note,
        firstName: firstName,
        lastName: lastName,
        stopId: stopId,
        driverId: trip.driver1Id!,
        amount: state.value!.amount,
      );
      var res = await repo.generateEcheck<EcheckPageController>(trip.companyCode!, req);
      var event = PosthotEcheckGeneratedLog(
        tenant: trip.companyCode!,
        tripNumber: trip.tripNumber!,
        tripId: tripId,
        stopName: stop?.companyName,
        stopId: stopId,
        reason: state.value!.reason!.name,
        success: (res.expressCheckNumber != null && res.expressCheckNumber!.trim().isNotEmpty)
            .toString(),
        note: req.note,
        amount: req.amount,
      );
      postHogService
          .postHogTrackEvent(PosthogTag.userGeneratedEcheck.toSnakeCase, {...event.toJson()});

      ref
          .read(httpClientProvider)
          .telemetryClient
          .trackEvent(name: "generate_echeck", additionalProperties: {...event.toJson()});
      await FirebaseAnalytics.instance
          .logEvent(name: "generate_echeck", parameters: {...event.toJson()});

      tripController.addEcheck(trip.id!, res);
      state = AsyncData(state.value!);
      if (context.mounted) {
        resetState();
        Navigator.of(context, rootNavigator: true).pop(res.expressCheckNumber);
      }
    }
  }

  Future<void> cancelEcheck(BuildContext context, String tripId, String echeckId) async {
    state = AsyncData(state.value!.copyWith(loadingEcheckId: echeckId));
    var trip = tripController.getTrip(tripId);

    if (trip == null) {
      state = AsyncData(state.value!.copyWith(loadingEcheckId: null));
      return;
    }
    var res = await repo.cancelEcheck<EcheckPageController>(trip.companyCode!, echeckId);
    tripController.updateEcheck(tripId, res);
    state = AsyncData(state.value!.copyWith(loadingEcheckId: null));
    var snackbar = SnackBarWrapper.getSnackBar(
        'ECheck ${trip.getEcheck(echeckId)?.expressCheckNumber ?? ""} has been canceled');
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  FutureOr<void> onError(Exception ex) {
    state = AsyncData(state.value!.copyWith(loadingEcheckId: null));
  }

  void resetState() {
    state = AsyncData(ECheckState(stopId: arg.stopId));
  }

  @override
  FutureOr<void> refreshPage(String page) {}
}

final echeckPageControllerProvider =
    AutoDisposeAsyncNotifierProviderFamily<EcheckPageController, ECheckState, ({String? stopId})>(
        EcheckPageController.new);
final echeckReasonsProvider =
    AutoDisposeFutureProviderFamily<List<GetAccessorialTypesResponse>, String>(
        (ref, companyCode) async {
  return await ref.read(eCheckRepoProvider).getEcheckReasons(companyCode);
});
