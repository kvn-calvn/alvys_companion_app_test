import 'package:freezed_annotation/freezed_annotation.dart';

import 'comcheck_settings.dart';
import 'office.dart';
import 'user_commission.dart';
import 'user_setting.dart';

part 'user_tenant.freezed.dart';
part 'user_tenant.g.dart';

@freezed
class UserTenant with _$UserTenant {
  factory UserTenant({
    @JsonKey(name: 'Role') String? role,
    @JsonKey(name: 'AssetId') String? assetId,
    @JsonKey(name: 'ContractorType') String? contractorType,
    @JsonKey(name: 'CompanyCode') String? companyCode,
    @JsonKey(name: 'InBonusPool') bool? inBonusPool,
    @JsonKey(name: 'IsDisabled') bool? isDisabled,
    @JsonKey(name: 'ComchekRestricted') bool? comchekRestricted,
    @JsonKey(name: 'CompanyOwnedAsset') bool? companyOwnedAsset,
    @JsonKey(name: 'CommissionRate') double? commissionRate,
    //  @JsonKey(name: 'DispatcherPaymentDetails') DispatcherPaymentInformationModel DispatcherPaymentDetails ,
    @JsonKey(name: 'Office') Office? office,
    @JsonKey(name: 'ComcheckSettings') ComcheckSettings? comcheckSettings,
    @Default(<String>[]) @JsonKey(name: 'Permissions') List<String> permissions,
    @Default(<UserSetting>[])
    @JsonKey(name: 'UserSettings')
        List<UserSetting> userSettings,
    @Default(<UserCommission>[])
    @JsonKey(name: 'Commission')
        List<UserCommission> commission,
  }) = _UserTenant;

  factory UserTenant.fromJson(Map<String, dynamic> json) =>
      _$UserTenantFromJson(json);
}
