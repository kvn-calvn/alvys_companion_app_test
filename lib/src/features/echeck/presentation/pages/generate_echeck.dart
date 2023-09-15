import '../../../../common_widgets/echeck_stop_card.dart';
import '../../../../common_widgets/unfocus_widget.dart';
import '../../../../constants/color.dart';
import '../../../authentication/presentation/sign_in_page.dart';
import '../controller/echeck_page_controller.dart';
import '../../../trips/domain/app_trip/stop.dart';
import '../../../trips/presentation/controller/trip_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../utils/app_theme.dart';

Future<T?> showGenerateEcheckDialog<T>(BuildContext context, String tripId) => showGeneralDialog<T>(
    context: context,
    useRootNavigator: true,
    pageBuilder: (c, anim1, anim2) => ProviderScope(
          parent: ProviderScope.containerOf(context),
          child: SafeArea(
              child: Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: GenerateEcheck(tripId),
          )),
        ));

class GenerateEcheck extends ConsumerStatefulWidget {
  final String tripId;
  const GenerateEcheck(this.tripId, {Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GenerateEcheckState();
}

class _GenerateEcheckState extends ConsumerState<GenerateEcheck> {
  GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();
  var amountMaskFormatter = MaskTextInputFormatter(
      mask: '\$##########', filter: {"#": RegExp(r'[0-9\.]')}, type: MaskAutoCompletionType.eager);
  @override
  Widget build(BuildContext context) {
    var notifier = ref.read(echeckPageControllerProvider.notifier);
    var state = ref.read(echeckPageControllerProvider);
    return UnfocusWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Generate E-Check',
            style: AlvysTheme.appbarTextStyle(context, true),
          ),
          leading: const SizedBox.shrink(),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: Form(
              key: formGlobalKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    autofocus: true,
                    inputFormatters: [amountMaskFormatter],
                    keyboardType: TextInputType.number,
                    onChanged: notifier.setAmount,
                    validator: notifier.validDouble,
                    decoration: const InputDecoration(hintText: "Amount"),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  DropdownButtonFormField(
                    isDense: true,
                    value: state.value!.reason,
                    hint: const Text('Reason'),
                    onChanged: notifier.setReason,
                    items: notifier.reasonsDropdown,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (state.value!.showStopDropdown) ...[
                    const Text("Select a Stop"),
                    for (Stop stop in ref.watch(tripControllerProvider).value!.getTrip(widget.tripId).stops!)
                      ECheckStopCard(
                        stop: stop,
                        onTap: notifier.setStopId,
                        currentStopId: state.value!.stopId,
                        selectedColor: ColorManager.primary(Theme.of(context).brightness),
                      ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                  Scrollbar(
                    thickness: 2,
                    child: TextField(
                      decoration: const InputDecoration(hintText: "Note"),
                      maxLines: 6,
                      minLines: 2,
                      keyboardType: TextInputType.multiline,
                      onChanged: notifier.setNote,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ButtonStyle1(
                    isDisable: !state.value!.showGenerateButton,
                    onPressAction: () async => await notifier.generateEcheck(formGlobalKey, context, widget.tripId),
                    title: "Generate",
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ButtonStyle1(
                    onPressAction: () => context.pop(),
                    title: "Cancel",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
