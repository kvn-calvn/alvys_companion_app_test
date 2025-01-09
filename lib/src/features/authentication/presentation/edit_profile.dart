import '../../../common_widgets/shimmers/edit_profile_shimmer.dart';
import '../../../common_widgets/unfocus_widget.dart';
import 'edit_profile_controller.dart';
import 'user_details_page.dart';
import '../../google_maps_helper/presentation/google_address_autocomplete.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../common_widgets/alvys_dropdown.dart';

class EditProfile extends ConsumerWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var editState = ref.watch(editProfileProvider);
    EditProfileNotifier editNotifier() =>
        ref.read(editProfileProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: UnfocusWidget(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: editState.isLoading
              ? const EditProfileShimmer()
              : SingleChildScrollView(
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileDetailCard(
                            title: 'Name', content: editState.value!.dto.name),
                        ProfileDetailCard(
                            title: 'Email',
                            content: editState.value!.dto.email),
                        ProfileDetailCard(
                            title: 'Phone',
                            content: editState.value!.dto.phone),
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Address',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                GoogleAddressAutocomplete(
                                    onResult: editNotifier().updateAddress,
                                    enabled:
                                        editState.value!.autocompleteEnabled),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('Auto-complete',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall),
                                    Checkbox.adaptive(
                                        visualDensity: VisualDensity.compact,
                                        value: editState
                                            .value!.autocompleteEnabled,
                                        onChanged: editNotifier()
                                            .setAutoCompleteEnabled),
                                  ],
                                ),
                                EditProfileDetailCard(
                                  title: 'Address Line 1',
                                  controller: editNotifier().street,
                                ),
                                EditProfileDetailCard(
                                  title: 'Address Line 2',
                                  controller: editNotifier().apartmentNumber,
                                ),
                                EditProfileDetailCard(
                                  title: 'City',
                                  controller: editNotifier().city,
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: EditProfileDetailCard(
                                        title: 'State',
                                        controller: editNotifier().addressState,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: EditProfileDetailCard(
                                        title: 'Zip',
                                        controller: editNotifier().zip,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (editState.value!.addressLoading)
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  color: Theme.of(context)
                                      .cardColor
                                      .withValues(alpha: 0.7),
                                  alignment: Alignment.center,
                                  child: const Text('Loading...'),
                                ),
                              )
                          ],
                        ),
                        Text(
                          'License Information',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        EditProfileDetailCard(
                          title: 'License #',
                          initString: editState.value!.dto.licenseNum,
                          onChanged: editNotifier().setLicenseNumber,
                        ),
                        const EditExpirationDate(),
                        Text(
                          'License Issue State',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        AlvysDropdown(
                          radius: 10,
                          elevation: 0,
                          textStyle: Theme.of(context).textTheme.bodyMedium,
                          initialItem: editState.value!.dto.licenseIssueState,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          items: EditProfileNotifier.states,
                          coverDisplayText: false,
                          border: BorderSide(
                              color: Colors.grey.withValues(alpha: 0.6),
                              width: 1),
                          includeTrailing: false,
                          onItemTap: editNotifier().setLicenseIssueState,
                          dropDownTitle: (item) => item,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () async {
                              await editNotifier().updateProfile(context);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Submit'),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class EditProfileDetailCard extends ConsumerWidget {
  final String title;
  final TextEditingController? controller;
  final void Function(String data)? onChanged;
  final String? initString;

  const EditProfileDetailCard(
      {super.key,
      required this.title,
      this.controller,
      this.initString,
      this.onChanged})
      : assert((controller != null &&
                (initString == null && onChanged == null)) ||
            (controller == null && (initString != null && onChanged != null)));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextFormField(
          controller: controller,
          enabled: !ref.watch(editProfileProvider).value!.autocompleteEnabled,
          initialValue: initString,
          onChanged: onChanged,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: const InputDecoration(
              isDense: true, contentPadding: EdgeInsets.all(12)),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }
}

class EditExpirationDate extends ConsumerWidget {
  const EditExpirationDate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var editState = ref.watch(editProfileProvider);
    var editNotifier = ref.read(editProfileProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expiration Date',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        GestureDetector(
          onTap: () async {
            var date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(DateTime.now().year - 5),
                lastDate: DateTime(DateTime.now().year + 10));
            if (date != null) {
              editNotifier.setExpirationDate(date);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.6), width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Text(
                    DateFormat('MMM d, yyyy', 'en_US')
                        .formatNullDate(editState.value!.dto.licenseExpiration),
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
