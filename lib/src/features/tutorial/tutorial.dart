import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tutorial_controller.dart';

enum WidgetShape { circle, square }

Size get screenSize => MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.implicitView!).size;

class Tutorial extends ConsumerStatefulWidget {
  final List<TutorialData> data;
  final bool finalTutorial;
  final Future<void> Function() skip;
  final Future<void> Function() endTutorial;
  const Tutorial(
      {required this.data, required this.finalTutorial, required this.skip, required this.endTutorial, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TutorialState();
}

class _TutorialState extends ConsumerState<Tutorial> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> circleAnimation;
  late List<Animation<Rect?>> clipAnimation;
  bool isCleaningUp = true;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(value: 0, vsync: this, duration: const Duration(milliseconds: 250));
    clipAnimation = widget.data
        .map((e) => RectTween(
                begin: Rect.fromCenter(
                    center: e.position.localToGlobal(Offset(e.position.size.width, e.position.size.height) / 2),
                    width: 1,
                    height: 1),
                end: (e.position.localToGlobal(Offset.zero) & e.position.size))
            .animate(controller))
        .toList();
    controller.forward().then((value) => isCleaningUp = false);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> cleanUp() async {
    if (isCleaningUp) return;
    isCleaningUp = true;

    await controller.fling(velocity: -2);
    ref.read(tutorialProvider).entry?.remove();
    ref.read(tutorialProvider).entry?.dispose();
    isCleaningUp = false;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).brightness.isLight ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedBuilder(
          animation: controller.view,
          builder: (context, child) {
            return Stack(
              children: [
                ClipPath(
                  clipper: TutorialClipper(widget.data, clipAnimation.map((e) => e.value).removeNulls.toList()),
                  child: Container(
                    decoration: BoxDecoration(
                      color: !Theme.of(context).brightness.isLight
                          ? const Color.fromRGBO(0, 0, 0, 0.8)
                          : const Color.fromRGBO(255, 255, 255, 0.8),
                    ),
                  ),
                ),
                ...widget.data.map((e) => e.content),
                GestureDetector(
                  onTap: () async {
                    if (isCleaningUp) return;
                    await cleanUp();
                    widget.skip();
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: screenSize.width,
                    height: screenSize.height,
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 10,
                  child: TextButton(
                      onPressed: () async {
                        if (isCleaningUp) return;
                        await cleanUp();
                        await widget.endTutorial();
                      },
                      child: const Text('Skip Tutorial')),
                ),
                Positioned(
                  bottom: 30,
                  right: 10,
                  child: TextButton(
                      onPressed: () async {
                        if (isCleaningUp) return;
                        await cleanUp();
                        widget.skip();
                      },
                      child: Text(widget.finalTutorial ? 'Finish' : 'Next')),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class TutorialClipper extends CustomClipper<Path> {
  final List<TutorialData> data;
  final List<Rect> sizes;
  TutorialClipper(this.data, this.sizes);

  @override
  Path getClip(Size size) {
    var path = Path();
    for (var i = 0; i < data.length; i++) {
      var element = data[i];
      var radius = sizes[i];
      if (element.shape == WidgetShape.square) {
        path.addRect(radius.inflate(element.inflate));
      } else {
        path.addOval(Rect.fromCircle(center: radius.center, radius: radius.longestSide / 2).inflate(element.inflate));
      }
    }
    path.addRect(Rect.fromLTWH(0.0, 0.0, screenSize.width, screenSize.height));

    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
