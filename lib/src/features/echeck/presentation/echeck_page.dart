import 'package:alvys3/src/common_widgets/echeck_card.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
import 'package:alvys3/src/features/echeck/presentation/echeck_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EcheckPage extends ConsumerStatefulWidget {
  const EcheckPage({required this.tripId, Key? key}) : super(key: key);

  final String tripId;

  @override
  // ignore: library_private_types_in_public_api
  _EcheckPageState createState() => _EcheckPageState();
}

class _EcheckPageState extends ConsumerState<EcheckPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    ref
        .read(echeckPageControllerProvider.notifier)
        .getEcheckList(widget.tripId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          'EChecks',
          textAlign: TextAlign.start,
          style: getBoldStyle(color: ColorManager.darkgrey, fontSize: 20),
        ),
        actions: const [],
        leading: IconButton(
          // 1
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
          color: ColorManager.darkgrey,
          onPressed: () {
            //Navigator.of(context).maybePop();
            GoRouter.of(context).pop();
          },
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF1F4F8),
      body: ListView(
        children: const [EcheckCard()],
      ),
    );
  }
}
