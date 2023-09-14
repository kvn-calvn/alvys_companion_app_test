import '../update_user_dto/update_user_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_profile_state.freezed.dart';

@freezed
class UpdateUserProfileState with _$UpdateUserProfileState {
  factory UpdateUserProfileState({required UpdateUserDTO dto, @Default(false) bool addressLoading}) =
      _UpdateUserProfileState;
}
