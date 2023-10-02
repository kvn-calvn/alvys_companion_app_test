import '../../utils/provider_args_saver.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/dummy_data.dart';
import '../../utils/magic_strings.dart';
import '../../utils/tablet_utils.dart';
import 'tutorial.dart';
import 'tutorial_widgets.dart';
import '../../routing/app_router.dart';
import '../../utils/global_error_handler.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TutorialElement {
  final LabeledGlobalKey globalKey;
  final Widget Function(RelativeRect position, RenderBox box) content;
  final WidgetShape shape;
  final double inflate;
  TutorialElement({required this.globalKey, required this.content, this.shape = WidgetShape.square, this.inflate = 0});
}

class TutorialData {
  final RenderBox position;
  final WidgetShape shape;
  final Widget content;
  final double inflate;

  TutorialData({
    required this.position,
    required this.shape,
    required this.content,
    required this.inflate,
  });
}

class TutorialElementGroup {
  final List<TutorialElement> elements;
  final Future<void> Function()? onSkip;

  TutorialElementGroup({required this.elements, this.onSkip});
}

class TutorialController {
  final LabeledGlobalKey refresh = LabeledGlobalKey('refresh'),
      tripCard = LabeledGlobalKey('tripCard'),
      sleepDropdown = LabeledGlobalKey('sleepDropdown'),
      stopCard = LabeledGlobalKey('stopCard'),
      infoTab = LabeledGlobalKey('infoTab'),
      settingsButton = LabeledGlobalKey('settingsButton'),
      profileButton = LabeledGlobalKey('profileButton'),
      echeckTab = LabeledGlobalKey('echeckTab'),
      echeckCard = LabeledGlobalKey('echeckCard'),
      echeckButton = LabeledGlobalKey('echeckButton'),
      documentTab = LabeledGlobalKey('documentTab'),
      documentCard = LabeledGlobalKey('documentCard'),
      documentButton = LabeledGlobalKey('documentButton');
  List<TutorialElementGroup> get tutorials => [
        TutorialElementGroup(
          elements: [
            TutorialElement(
              globalKey: sleepDropdown,
              content: (pos, box) => SleepButtonTutorial(
                position: pos,
                box: box,
              ),
            ),
            TutorialElement(
              globalKey: refresh,
              content: (pos, box) => RefreshTutorial(
                position: pos,
                box: box,
              ),
              shape: WidgetShape.circle,
            ),
            TutorialElement(
              globalKey: tripCard,
              content: (pos, box) => TripCardTutorial(
                position: pos,
                box: box,
              ),
            ),
          ],
          onSkip: () async {
            navigator.goNamed(
              RouteName.tripDetails.name,
              pathParameters: {ParamType.tripId.name: testTrip.id!},
              queryParameters: {ParamType.tabIndex.name: 0.toString()},
            );
          },
        ),
        TutorialElementGroup(
          elements: [
            TutorialElement(
              globalKey: infoTab,
              content: (pos, box) => TripDetailsTabTutorial(
                position: pos,
                box: box,
              ),
            ),
            TutorialElement(
              globalKey: stopCard,
              content: (pos, box) => StopCardTutorial(
                position: pos,
                box: box,
              ),
            ),
          ],
          onSkip: () async {
            TabletUtils.instance.detailsController.animateTo(1, duration: Duration.zero);

            await Future.delayed(TabletUtils.instance.detailsController.animationDuration);
          },
        ),
        TutorialElementGroup(
          elements: [
            TutorialElement(
              globalKey: echeckTab,
              content: (pos, box) => EcheckTabTutorial(
                position: pos,
                box: box,
              ),
            ),
            TutorialElement(
              globalKey: echeckCard,
              content: (pos, box) => EcheckCardTutorial(
                position: pos,
                box: box,
              ),
            ),
            TutorialElement(
                globalKey: echeckButton,
                content: (pos, box) => GenerateEcheckButtonTutorial(
                      position: pos,
                      box: box,
                    ),
                shape: WidgetShape.circle),
          ],
          onSkip: () async {
            TabletUtils.instance.detailsController.animateTo(2, duration: Duration.zero);
            await Future.delayed(TabletUtils.instance.detailsController.animationDuration);
          },
        ),
        TutorialElementGroup(
          elements: [
            TutorialElement(
              globalKey: documentTab,
              content: (pos, box) => TripDocumentsTabTutorial(
                position: pos,
                box: box,
              ),
            ),
            TutorialElement(
              globalKey: documentCard,
              content: (pos, box) => TripDocumentsCardTutorial(
                position: pos,
                box: box,
              ),
            ),
            TutorialElement(
                globalKey: documentButton,
                content: (pos, box) => TripDocumentUploadButton(
                      position: pos,
                      box: box,
                    ),
                shape: WidgetShape.circle),
          ],
          onSkip: () async {
            // TabletUtils.instance.detailsController.animateTo(2, duration: Duration.zero);
            // await Future.delayed(TabletUtils.instance.detailsController.animationDuration);
          },
        ),
        // TutorialElementGroup(
        //   elements: [
        //     TutorialElement(
        //       globalKey: infoTab,
        //       content: (pos, box) => TripDetailsTabTutorial(
        //         position: pos,
        //         box: box,
        //       ),
        //     ),
        //     TutorialElement(
        //       globalKey: stopCard,
        //       content: (pos, box) => StopCardTutorial(
        //         position: pos,
        //         box: box,
        //       ),
        //     ),
        //   ],
        //   onSkip: () async {
        //     TabletUtils.instance.detailsController.animateTo(2, duration: Duration.zero);
        //   },
        // )
      ];

  final GlobalKey<NavigatorState> navKey;
  final GoRouter navigator;
  final SharedPreferences pref;
  final FirstInstallNotifier firstInstall;
  int index = 0;
  OverlayEntry? entry;
  void Function()? onEnd;
  TutorialController({required this.firstInstall, required this.navigator, required this.navKey, required this.pref});
  Future<void> endTutorial() async {
    index = 0;
    firstInstall.setState(false);
    await pref.setBool(SharedPreferencesKey.firstInstall.name, false);
    onEnd?.call();
  }

  void startTutorial(BuildContext context, void Function() onEnd, [int startIndex = 0, int? endIndex]) {
    if (index == tutorials.length || !firstInstall.currentState) {
      index = 0;
      return;
    }
    this.onEnd = onEnd;
    endIndex ??= tutorials.length;
    index = startIndex;
    var item = tutorials[index];

    entry = OverlayEntry(
        builder: (c) => Tutorial(
              data: item.elements
                  .map((e) {
                    var position = e.globalKey.getKeyPosition(context)!;
                    // if (position == null) return null;
                    return TutorialData(
                      position: position.renderBox,
                      shape: e.shape,
                      content: e.content(position.relativeRect, position.renderBox),
                      inflate: e.inflate,
                    );
                  })
                  .removeNulls
                  .toList(),
              endTutorial: () async {
                await endTutorial();
              },
              skip: () async {
                if (index >= endIndex! - 1) {
                  await endTutorial();
                  return;
                }
                await item.onSkip?.call();
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  next(context, endIndex!);
                });
              },
              finalTutorial: index >= endIndex! - 1,
            ));
    Overlay.of(context, rootOverlay: true).insert(entry!);
  }

  void showTutorialSection(BuildContext context, int startIndex, int endIndex, void Function() onEnd) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // this.onEnd = onEnd;
      firstInstall.setState(true);
      startTutorial(context, onEnd, startIndex, endIndex);
      firstInstall.setState(false);
    });
  }

  void next(BuildContext context, int endIndex) {
    index++;
    startTutorial(context, onEnd!, index, endIndex);
  }
}

final tutorialProvider = Provider<TutorialController>((ref) {
  return TutorialController(
    navKey: ref.read(globalErrorHandlerProvider).navKey,
    navigator: ref.read(getRouter),
    firstInstall: ref.read(firstInstallProvider.notifier),
    pref: ref.read(sharedPreferencesProvider)!,
  );
});

MapEntry<Rect, RenderBox> getKeyDetails(GlobalKey key) {
  RenderBox target = key.currentContext!.findRenderObject() as RenderBox;
  Rect markRect = target.localToGlobal(Offset.zero) & target.size;
  return MapEntry(markRect, target);
}

final firstInstallProvider = NotifierProvider<FirstInstallNotifier, bool>(FirstInstallNotifier.new);

class FirstInstallNotifier extends Notifier<bool> {
  final bool firstInstall;

  FirstInstallNotifier([this.firstInstall = true]);
  @override
  bool build() {
    state = firstInstall;
    return state;
  }

  void setState(bool x) => state = x;

  bool get currentState => state;
}
