import 'package:freezed_annotation/freezed_annotation.dart';

import '../driver_user/driver_user.dart';

part 'update_user_dto.freezed.dart';
part 'update_user_dto.g.dart';

@freezed
class UpdateUserDTO with _$UpdateUserDTO {
  factory UpdateUserDTO({
    @JsonKey(name: 'UserId') required String userId,
    @JsonKey(name: 'Name') String? name,
    @JsonKey(name: 'Street') String? street,
    @JsonKey(name: 'ApartmentNumber') String? apartmentNumber,
    @JsonKey(name: 'City') String? city,
    @JsonKey(name: 'Zip') String? zip,
    @JsonKey(name: 'State') String? state,
    @JsonKey(name: 'Phone') String? phone,
    @JsonKey(name: 'Email') String? email,
    @JsonKey(name: 'LicenseNum') String? licenseNum,
    @JsonKey(name: 'LicenseIssueState') String? licenseIssueState,
    @JsonKey(name: 'LicenseExpiration') DateTime? licenseExpiration,
  }) = _UpdateUserDTO;
  UpdateUserDTO._();
  factory UpdateUserDTO.fromJson(Map<String, dynamic> json) => _$UpdateUserDTOFromJson(json);

  UpdateUserDTO updateFromUser(DriverUser? user) => user == null
      ? this
      : UpdateUserDTO(
          userId: user.id!,
          street: user.address?.street == street ? null : street,
          apartmentNumber: user.address?.apartmentNumber == apartmentNumber ? null : apartmentNumber,
          city: user.address?.city == city ? null : city,
          zip: user.address?.zip == zip ? null : zip,
          state: user.address?.state == state ? null : state,
          licenseNum: user.driversLicenceNumber == licenseNum ? null : licenseNum,
          licenseIssueState: user.driversLicenceState == licenseIssueState ? null : licenseIssueState,
          licenseExpiration:
              (user.driversLicenceExpirationDate?.isAtSameMomentAs(licenseExpiration ?? DateTime.now()) ?? false)
                  ? null
                  : licenseExpiration,
        );
}
