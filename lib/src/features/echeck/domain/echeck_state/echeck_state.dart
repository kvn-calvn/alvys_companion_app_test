import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../utils/magic_strings.dart';

part 'echeck_state.freezed.dart';

@freezed
class ECheckState with _$ECheckState {
  factory ECheckState({
    @Default(0) double amount,
    String? reason,
    String? stopId,
    String? loadingEcheckNumber,
    @Default('') String note,
  }) = _ECheckState;

  ECheckState._();

  bool get showGenerateButton {
    if (amount == 0) return false;
    if (reason.isNullOrEmpty) return false;
    if (stopId.isNullOrEmpty && showStopDropdown) return false;
    return true;
  }

  bool get showStopDropdown => stopReasons.contains(reason);
  List<String> get reasons => EcheckReason.values.map((e) => e.name.splitCamelCaseWord().titleCase).toList();
  List<String> get stopReasons =>
      [EcheckReason.lumper, EcheckReason.extraLaborDelivery].map((e) => e.name.splitCamelCaseWord().titleCase).toList();
}
