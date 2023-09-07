import 'package:alvys3/src/utils/extensions.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'echeck_state.freezed.dart';
part 'echeck_state.g.dart';

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
  factory ECheckState.fromJson(Map<String, dynamic> json) => _$ECheckStateFromJson(json);

  bool get showGenerateButton {
    if (amount == 0) return false;
    if (reason.isNullOrEmpty) return false;
    if (stopId.isNullOrEmpty && showStopDropdown) return false;
    return true;
  }

  bool get showStopDropdown => stopReasons.containsElement(reason);
  List<String> get reasons => EcheckReason.values.map((e) => e.name.splitCamelCaseWord().titleCase).toList();
  List<String> get stopReasons =>
      [EcheckReason.lumper, EcheckReason.extraLaborDelivery].map((e) => e.name.splitCamelCaseWord().titleCase).toList();
}
