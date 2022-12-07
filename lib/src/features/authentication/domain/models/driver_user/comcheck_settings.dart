import 'package:freezed_annotation/freezed_annotation.dart';

part 'comcheck_settings.freezed.dart';
part 'comcheck_settings.g.dart';

@freezed
class ComcheckSettings with _$ComcheckSettings {
  factory ComcheckSettings({
    @JsonKey(name: 'Percentage') double? percentage,
    @JsonKey(name: 'Cap') double? cap,
  }) = _ComcheckSettings;

  factory ComcheckSettings.fromJson(Map<String, dynamic> json) =>
      _$ComcheckSettingsFromJson(json);
}
