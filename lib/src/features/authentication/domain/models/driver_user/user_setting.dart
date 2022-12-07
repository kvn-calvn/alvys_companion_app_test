import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_setting.freezed.dart';
part 'user_setting.g.dart';

@freezed
class UserSetting with _$UserSetting {
  factory UserSetting({
    @JsonKey(name: 'Name') String? name,
    @JsonKey(name: 'Value') String? value,
  }) = _UserSetting;

  factory UserSetting.fromJson(Map<String, dynamic> json) =>
      _$UserSettingFromJson(json);
}
