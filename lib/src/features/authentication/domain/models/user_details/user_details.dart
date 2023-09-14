import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_details.freezed.dart';
part 'user_details.g.dart';

@freezed
class UserDetails with _$UserDetails {
  factory UserDetails({
    required String id,
    @JsonKey(name: 'Email') required String email,
    @JsonKey(name: 'Phone') required String phone,
    @JsonKey(name: 'UserTenants') @Default(<UserTenantInfo>[]) List<UserTenantInfo> userTenants,
  }) = _UserDetails;

  factory UserDetails.fromJson(Map<String, dynamic> json) => _$UserDetailsFromJson(json);
}

@freezed
class UserTenantInfo with _$UserTenantInfo {
  factory UserTenantInfo({
    @JsonKey(name: 'CompanyCode') required String companyCode,
    @JsonKey(name: 'Permissions') @Default(<String>[]) List<String> permissions,
  }) = _UserTenantInfo;

  factory UserTenantInfo.fromJson(Map<String, dynamic> json) => _$UserTenantInfoFromJson(json);
}
