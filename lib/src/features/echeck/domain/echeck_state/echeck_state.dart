import 'package:alvys3/src/features/echeck/domain/accessorial_types/accessorial_types.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'echeck_state.freezed.dart';

@freezed
class ECheckState with _$ECheckState {
  factory ECheckState({
    @Default(0) double amount,
    GetAccessorialTypesResponse? reason,
    String? stopId,
    String? loadingEcheckId,
    @Default('') String note,
  }) = _ECheckState;

  ECheckState._();
  bool get showGenerateButton {
    if (amount == 0) return false;
    if (reason == null) return false;
    if (stopId.isNullOrEmpty && showStopDropdown) return false;
    return true;
  }

  bool get showStopDropdown => reason?.requiresStop ?? false;
}
