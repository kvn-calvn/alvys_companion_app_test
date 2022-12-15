import 'package:alvys3/src/common_widgets/echeck_stop_card.dart';
import 'package:alvys3/src/common_widgets/unfocus_widget.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/features/authentication/presentation/sign_in_phonenumber/sign_in_page.dart';
import 'package:alvys3/src/features/echeck/presentation/echeck_page_controller.dart';
import 'package:alvys3/src/features/trips/domain/app_trip/stop.dart';
import 'package:alvys3/src/features/trips/presentation/trip/trip_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class GenerateEcheck extends ConsumerStatefulWidget {
  const GenerateEcheck({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GenerateEcheckState();
}

class _GenerateEcheckState extends ConsumerState<GenerateEcheck> {
  final formGlobalKey = GlobalKey<FormState>();
  var amountMaskFormatter = MaskTextInputFormatter(
      mask: '\$####',
      filter: {"#": RegExp(r'[0-9\.]')},
      type: MaskAutoCompletionType.eager);
  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Generate E-Check',
          ),
          leading: IconButton(
            icon: Icon(
              Icons.adaptive.arrow_back,
            ),
            onPressed: () {
              GoRouter.of(context).pop();
            },
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  autofocus: true,
                  inputFormatters: [amountMaskFormatter],
                  keyboardType: TextInputType.number,
                  onChanged:
                      ref.read(echeckPageControllerProvider.notifier).setAmount,
                  decoration: const InputDecoration(hintText: "Amount"),
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButtonFormField(
                    isDense: true,
                    value:
                        ref.watch(echeckPageControllerProvider).value!.reason,
                    hint: const Text('Reason'),
                    onChanged: ref
                        .read(echeckPageControllerProvider.notifier)
                        .setReason,
                    items: ref
                        .watch(echeckPageControllerProvider.notifier)
                        .reasonsDropdown),
                const SizedBox(
                  height: 16,
                ),
                if (ref
                    .watch(echeckPageControllerProvider.notifier)
                    .showStopDropdown) ...[
                  const Text("Select a Stop"),
                  for (Stop stop in ref
                      .watch(tripPageControllerProvider)
                      .value!
                      .currentTrip
                      .stops!)
                    ECheckStopCard(
                      stopId: stop.stopId!,
                      stopType: stop.stopType!,
                      stopName: stop.companyName!,
                      onTap: ref
                          .read(echeckPageControllerProvider.notifier)
                          .setStopId,
                      currentStopId:
                          ref.watch(echeckPageControllerProvider).value!.stopId,
                      city: stop.city!,
                      state: stop.state!,
                      zip: stop.zip!,
                      selectedColor:
                          ColorManager.primary(Theme.of(context).brightness),
                    ),
                  // const ECheckStopCard(
                  //   stopType: "Pickup",
                  //   stopName: "Eufaula Fresh Proc",
                  //   city: "Eufaula",
                  //   state: "AL",
                  //   zip: "36027",
                  // ),
                  // const ECheckStopCard(
                  //   stopType: "Delivery",
                  //   stopName: "Stop & Shop Freetown",
                  //   city: "Freetown",
                  //   state: "MA",
                  //   zip: "02702",
                  // ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
                const Scrollbar(
                  thickness: 2,
                  child: TextField(
                    decoration: InputDecoration(hintText: "Note"),
                    maxLines: 6,
                    minLines: 2,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ButtonStyle1(
                    isDisable: !ref
                        .watch(echeckPageControllerProvider.notifier)
                        .showGenerateButton,
                    onPressAction: () {},
                    title: "Generate")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
