import 'dart:async';

import '../domain/models/update_user_dto/update_user_dto.dart';
import '../domain/models/update_user_profile_state/update_user_profile_state.dart';
import 'auth_provider_controller.dart';
import '../../../utils/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../google_maps_helper/domain/google_places_details_result.dart';

final editProfileProvider =
    AutoDisposeAsyncNotifierProvider<EditProfileNotifier, UpdateUserProfileState>(EditProfileNotifier.new);

class EditProfileNotifier extends AutoDisposeAsyncNotifier<UpdateUserProfileState> implements IAppErrorHandler {
  late AuthProviderNotifier auth;
  late TextEditingController street, city, addressState, zip, apartmentNumber;
  @override
  FutureOr<UpdateUserProfileState> build() {
    auth = ref.read(authProvider.notifier);
    var user = auth.stateUser!;

    var data = UpdateUserDTO(
        userId: user.id!,
        name: user.name ?? '',
        street: user.address?.street ?? '',
        city: user.address?.city ?? '',
        zip: user.address?.zip ?? '',
        apartmentNumber: user.address?.apartmentNumber ?? '',
        state: user.address?.state ?? '',
        phone: user.phone ?? '',
        email: user.email ?? '',
        licenseNum: user.driversLicenceNumber ?? '',
        licenseIssueState: user.driversLicenceState ?? '',
        licenseExpiration: user.driversLicenceExpirationDate);
    street = TextEditingController(text: data.street);
    city = TextEditingController(text: data.city);
    addressState = TextEditingController(text: data.state);
    apartmentNumber = TextEditingController(text: data.apartmentNumber);
    zip = TextEditingController(text: data.zip);
    return UpdateUserProfileState(dto: data);
  }

  Future<void> updateAddress(Future<GooglePlacesDetailsResult> res) async {
    state = AsyncData(state.value!.copyWith(addressLoading: true));
    var result = (await res).result;
    street = TextEditingController(text: result.street);
    city = TextEditingController(text: result.city);
    addressState = TextEditingController(text: result.state);
    apartmentNumber = TextEditingController(text: result.apartmentNumber);
    zip = TextEditingController(text: result.zip);
    state = AsyncData(state.value!.copyWith(
        dto: state.value!.dto.copyWith(
      state: result.street,
      city: result.city,
      street: result.street,
      zip: result.zip,
    )));
    state = AsyncData(state.value!.copyWith(addressLoading: false));
  }

  void setExpirationDate(DateTime date) =>
      state = AsyncData(state.value!.copyWith(dto: state.value!.dto.copyWith(licenseExpiration: date)));
  void setLicenseIssueState(String? issueState) {
    if (issueState != null) {
      state = AsyncData(state.value!.copyWith(dto: state.value!.dto.copyWith(licenseIssueState: issueState)));
    }
  }

  void setLicenseNumber(String data) {
    state = AsyncData(state.value!.copyWith(dto: state.value!.dto.copyWith(licenseNum: data)));
  }

  Future<void> updateProfile(BuildContext context) async {
    state = AsyncData(state.value!.copyWith(
        dto: state.value!.dto.copyWith(
      state: addressState.text,
      city: city.text,
      street: street.text,
      zip: zip.text,
    )));
    state = const AsyncLoading();
    await auth.updateUserProfile<EditProfileNotifier>(state.value!.dto.updateFromUser(auth.stateUser));
    state = AsyncData(state.value!);
    if (context.mounted) context.pop();
  }

  void setAutoCompleteEnabled(bool? val) => state = AsyncData(state.value!.copyWith(autocompleteEnabled: val ?? true));
  @override
  FutureOr<void> onError() {
    state = AsyncData(state.value!);
  }

  static const List<String> states = [
    'AK',
    'AL',
    'AR',
    'AZ',
    'CA',
    'CO',
    'CT',
    'DE',
    'FL',
    'GA',
    'HI',
    'IA',
    'ID',
    'IL',
    'IN',
    'KS',
    'KY',
    'LA',
    'MA',
    'MD',
    'ME',
    'MI',
    'MN',
    'MO',
    'MS',
    'MT',
    'NC',
    'ND',
    'NE',
    'NH',
    'NJ',
    'NM',
    'NV',
    'NY',
    'OH',
    'OK',
    'OR',
    'PA',
    'RI',
    'SC',
    'SD',
    'TN',
    'TX',
    'UT',
    'VA',
    'VT',
    'WA',
    'WI',
    'WV',
    'WY',
  ];
}
