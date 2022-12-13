import 'package:freezed_annotation/freezed_annotation.dart';

part 'echeck_state.freezed.dart';
part 'echeck_state.g.dart';

@freezed
class ECheckState with _$ECheckState {
  factory ECheckState({
    @Default('') String amount,
    String? reason,
    String? stopId,
    @Default('') String note,
  }) = _ECheckState;

  factory ECheckState.fromJson(Map<String, dynamic> json) =>
      _$ECheckStateFromJson(json);
}
