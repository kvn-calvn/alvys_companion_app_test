import 'package:alvys3/src/common_widgets/echeck_stop_card.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/features/authentication/presentation/sign_in_phonenumber/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class GenerateEcheck extends StatefulWidget {
  const GenerateEcheck({Key? key}) : super(key: key);

  @override
  State<GenerateEcheck> createState() => _GenerateEcheckState();
}

class _GenerateEcheckState extends State<GenerateEcheck> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController amountTF = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();

  String? selectedValue = "Reason";
  List<DropdownMenuItem<String>> get reasons {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
          value: "Reason",
          child: Text(
            "Reason",
            style: TextStyle(color: Colors.grey),
          )),
      const DropdownMenuItem(value: "Advance", child: Text("Advance")),
      const DropdownMenuItem(
          value: "Extra Labor Delivery", child: Text("Extra Labor Delivery")),
      const DropdownMenuItem(value: "Lumper", child: Text("Lumper")),
      const DropdownMenuItem(value: "Pallet Fee", child: Text("Pallet Fee")),
      const DropdownMenuItem(
          value: "Trailer Wash", child: Text("Trailer Wash")),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    var amountMaskFormatter = MaskTextInputFormatter(
        mask: '\$####',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Generate E-Check',
        ),
        leading: IconButton(
          // 1
          icon: Icon(
            Icons.adaptive.arrow_back,
          ),
          onPressed: () {
            //Navigator.of(context).maybePop();
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
                controller: amountTF,
                autofocus: true,
                inputFormatters: [amountMaskFormatter],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Amount"),
              ),
              const SizedBox(
                height: 16,
              ),
              DropdownButtonFormField(
                  isDense: true,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: .5, color: ColorManager.lightgrey),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: ColorManager.primary(Brightness.dark)),
                        borderRadius: BorderRadius.circular(15),
                      ),

                      /*
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),*/
                      filled: true,
                      fillColor: ColorManager.darkgrey),
                  validator: (value) =>
                      value == null ? "Select a country" : null,
                  dropdownColor: ColorManager.darkgrey,
                  value: selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                  items: reasons),
              const SizedBox(
                height: 16,
              ),
              const Text("Select a Stop"),
              const ECheckStopCard(
                stopType: "Pickup",
                stopName: "Eufaula Fresh Proc",
                city: "Eufaula",
                state: "AL",
                zip: "36027",
              ),
              const ECheckStopCard(
                stopType: "Delivery",
                stopName: "Stop & Shop Freetown",
                city: "Freetown",
                state: "MA",
                zip: "02702",
              ),
              const SizedBox(
                height: 16,
              ),
              const TextField(
                decoration: InputDecoration(hintText: "Note"),
                maxLines: null,
                minLines: 2,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(
                height: 16,
              ),
              ButtonStyle1(onPressAction: () {}, title: "Generate")
            ],
          ),
        ),
      ),
    );
  }
}
