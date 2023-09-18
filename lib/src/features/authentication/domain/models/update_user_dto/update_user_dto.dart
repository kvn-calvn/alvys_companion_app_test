import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_dto.freezed.dart';
part 'update_user_dto.g.dart';

@freezed
class UpdateUserDTO with _$UpdateUserDTO {
  factory UpdateUserDTO({
    @JsonKey(name: 'UserId') required String userId,
    @JsonKey(name: 'Name') required String name,
    @JsonKey(name: 'Street') required String street,
    @JsonKey(name: 'ApartmentNumber') required String apartmentNumber,
    @JsonKey(name: 'City') required String city,
    @JsonKey(name: 'Zip') required String zip,
    @JsonKey(name: 'State') required String state,
    @JsonKey(name: 'Phone') required String phone,
    @JsonKey(name: 'Email') required String email,
    @JsonKey(name: 'LicenseNum') required String licenseNum,
    @JsonKey(name: 'LicenseIssueState') required String licenseIssueState,
    @JsonKey(name: 'LicenseExpiration') DateTime? licenseExpiration,
  }) = _UpdateUserDTO;

  factory UpdateUserDTO.fromJson(Map<String, dynamic> json) => _$UpdateUserDTOFromJson(json);
}
