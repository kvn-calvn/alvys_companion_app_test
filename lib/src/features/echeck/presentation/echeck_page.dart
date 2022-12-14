import 'package:alvys3/src/common_widgets/echeck_card.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/features/trips/presentation/trip/trip_page_controller.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../utils/extensions.dart';

class EcheckPage extends ConsumerStatefulWidget {
  const EcheckPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EcheckPageState createState() => _EcheckPageState();
}

class _EcheckPageState extends ConsumerState<EcheckPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var echecks =
        ref.watch(tripPageControllerProvider).value!.currentTrip.eChecks;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'E-Checks',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).pushNamed(RouteName.generateEcheck.name);
        },
        backgroundColor: ColorManager.primary(Theme.of(context).brightness),
        child: const Icon(Icons.attach_money, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(tripPageControllerProvider.notifier)
              .refreshCurrentTrip();
        },
        child: echecks.isNullOrEmpty
            ? const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Center(
                  child: Text("No Echecks on this Trip"),
                ),
              )
            : ListView.builder(
                itemCount: echecks!.length,
                itemBuilder: (context, index) => EcheckCard(
                  eCheck: echecks[index],
                ),
              ),
      ),
    );
  }
}
