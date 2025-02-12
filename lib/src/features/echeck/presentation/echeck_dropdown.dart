import 'package:alvys3/src/features/echeck/domain/accessorial_types/accessorial_types.dart';
import 'package:alvys3/src/utils/extensions.dart';

import 'controller/echeck_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EcheckReasonsDropdown extends ConsumerWidget {
  final String companyCode;
  final String? stopId;
  const EcheckReasonsDropdown(this.companyCode, this.stopId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var reasonsState = ref.watch(echeckReasonsProvider.call(companyCode));
    var reasons = reasonsState.when<List<GetAccessorialTypesResponse>>(
        data: (data) => data.distinctBy((x) => x.name).toList(),
        error: (error, trace) => [],
        loading: () => []);
    var notifier = ref.read(echeckPageControllerProvider.call((stopId: stopId)).notifier);
    var state = ref.watch(echeckPageControllerProvider.call((stopId: stopId)));
    return DropdownButtonFormField(
      value: state.value!.reason,
      menuMaxHeight: 240,
      decoration: InputDecoration(hintText: reasonsState.isLoading ? "Reasons Loading" : "Reason"),
      onChanged: notifier.setReason,
      items: reasons
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.name),
              ))
          .toList(),
    );
  }
}
