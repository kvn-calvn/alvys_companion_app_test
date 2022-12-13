import 'dart:async';
import 'package:alvys3/src/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/echeck_state/echeck_state.dart';

class EcheckPageController extends AutoDisposeAsyncNotifier<ECheckState> {
  final List<String> reasons = [
    'Advance',
    'Trailer Wash',
    'Extra Labor Delivery',
    'Lumper',
    'Pallet Fee'
  ];
  final List<String> stopReasons = [
    'Late Fee',
    'Extra Labor Delivery',
    'Lumper',
  ];

  @override
  FutureOr<ECheckState> build() {
    state = AsyncValue.data(ECheckState());
    return state.value!;
  }

  List<DropdownMenuItem<String>> get reasonsDropdown => reasons
      .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ))
      .toList();
  bool get showStopDropdown => stopReasons.containsElement(state.value!.reason);
  void setReason(String? reason) {
    state = AsyncValue.data(state.value!.copyWith(reason: reason));
    if (!showStopDropdown) {
      setStopId(null);
    }
  }

  void setStopId(String? stopId) {
    state = AsyncValue.data(state.value!.copyWith(stopId: stopId));
  }

  void setAmount(String? amount) {
    state = AsyncValue.data(
        state.value!.copyWith(amount: amount.currencyNumbersOnly));
  }

  bool get showGenerateButton {
    var stateValue = state.value!;
    if (stateValue.amount.isNullOrEmpty) return false;
    if (stateValue.reason.isNullOrEmpty) return false;
    if (stateValue.stopId.isNullOrEmpty && showStopDropdown) return false;
    return true;
  }
}

final echeckPageControllerProvider =
    AutoDisposeAsyncNotifierProvider<EcheckPageController, ECheckState>(
        EcheckPageController.new);
