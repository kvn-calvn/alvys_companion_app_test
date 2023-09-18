import 'package:freezed_annotation/freezed_annotation.dart';

import '../update_user_dto/update_user_dto.dart';

part 'update_user_profile_state.freezed.dart';

@freezed
class UpdateUserProfileState with _$UpdateUserProfileState {
  factory UpdateUserProfileState(
      {required UpdateUserDTO dto,
      @Default(true) bool autocompleteEnabled,
      @Default(false) bool addressLoading}) = _UpdateUserProfileState;
}
