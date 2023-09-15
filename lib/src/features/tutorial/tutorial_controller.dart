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
  final Future<void> Function()? onSkip;
  final double inflate;
  TutorialElement(
      {required this.globalKey, required this.content, this.onSkip, this.shape = WidgetShape.square, this.inflate = 0});
}

class TutorialController {
  final LabeledGlobalKey refresh = LabeledGlobalKey('refresh'),
      tripCard = LabeledGlobalKey('sleepDropdown'),
      sleepDropdown = LabeledGlobalKey('tripCard'),
      stopCard = LabeledGlobalKey('stopCard'),
      stopActions = LabeledGlobalKey('stopActions'),
      settingsButton = LabeledGlobalKey('settingsButton'),
      profileButton = LabeledGlobalKey('profileButton'),
      echeckTab = LabeledGlobalKey('echeckTab'),
      echeckButton = LabeledGlobalKey('echeckButton'),
      documentTab = LabeledGlobalKey('documentTab'),
      documentButton = LabeledGlobalKey('documentButton');
  List<TutorialElement> get tutorials => [
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
            globalKey: profileButton,
            content: (pos, box) => ProfileTutorial(
                  position: pos,
                  box: box,
                ),
            shape: WidgetShape.circle,
            inflate: 20),
        TutorialElement(
            globalKey: settingsButton,
            content: (pos, box) => SettingsTutorial(
                  position: pos,
                  box: box,
                ),
            shape: WidgetShape.circle,
            inflate: 20),
      ];

  final GlobalKey<NavigatorState> navKey;
  final GoRouter navigator;
  int index = 0;
  OverlayEntry? entry;
  TutorialController({required this.navigator, required this.navKey});

  void startTutorial(BuildContext context) {
    if (index == tutorials.length) return;
    var item = tutorials[index];
    var res = item.globalKey.getKeyPosition(context)!;
    entry = OverlayEntry(
        builder: (context) => Tutorial(
              position: res.widgetBox,
              shape: item.shape,
              endTutorial: () async {
                index = tutorials.length;
              },
              skip: () async {
                await item.onSkip?.call();
                if (context.mounted) next(context);
              },
              inflate: item.inflate,
              content: item.content(res.position, res.widgetBox),
            ));
    Overlay.of(context, rootOverlay: true).insert(entry!);
  }

  void next(BuildContext context) {
    index++;
    startTutorial(context);
  }
}

final tutorialProvider = Provider<TutorialController>((ref) {
  return TutorialController(navKey: ref.read(globalErrorHandlerProvider).navKey, navigator: ref.read(getRouter));
});
