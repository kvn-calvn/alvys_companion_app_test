import 'tutorial_controller.dart';
import '../../utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum WidgetShape { circle, square }

Size get screenSize => MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.implicitView!).size;

class Tutorial extends ConsumerStatefulWidget {
  final RenderBox position;
  final WidgetShape shape;
  final Widget content;
  final double inflate;
  final Future<void> Function() skip;
  final Future<void> Function() endTutorial;
  const Tutorial(
      {super.key,
      required this.inflate,
      required this.content,
      required this.position,
      required this.shape,
      required this.skip,
      required this.endTutorial});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TutorialState();
}

class _TutorialState extends ConsumerState<Tutorial> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> circleAnimation;
  late Animation<Rect?> clipAnimation;
  bool isCleaningUp = true;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(value: 0, vsync: this, duration: const Duration(milliseconds: 250));
    clipAnimation = RectTween(
            begin: Rect.fromCenter(
                center: widget.position.localToGlobal(Offset.zero),
                width: screenSize.height * 2,
                height: screenSize.height * 2),
            end: (widget.position.localToGlobal(Offset.zero) & widget.position.size))
        .animate(controller);
    controller.forward().then((value) => setState(() => isCleaningUp = false));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> cleanUp() async {
    if (isCleaningUp) return;
    setState(() {
      isCleaningUp = true;
    });
    await controller.fling(velocity: -2);
    ref.read(tutorialProvider).entry?.remove();
    setState(() {
      isCleaningUp = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedBuilder(
          animation: controller.view,
          builder: (context, child) {
            return GestureDetector(
              onTap: () async {
                if (isCleaningUp) return;
                await cleanUp();
                widget.skip();
              },
              child: Stack(
                children: [
                  ClipPath(
                    clipper: TutorialClipper(
                        clipAnimation.value ?? Rect.zero, widget.position, widget.shape, widget.inflate),
                    child: Container(
                      color: !Theme.of(context).brightness.isLight
                          ? const Color.fromRGBO(0, 0, 0, 0.8)
                          : const Color.fromRGBO(255, 255, 255, 0.8),
                    ),
                  ),
                  widget.content,
                  Positioned(
                    bottom: 30,
                    left: 10,
                    child: TextButton(
                        onPressed: () async {
                          if (isCleaningUp) return;
                          await cleanUp();
                          widget.endTutorial();
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
                        child: const Text('Next')),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class TutorialClipper extends CustomClipper<Path> {
  final WidgetShape shape;
  final Rect radius;
  final double inflate;
  final RenderBox position;
  TutorialClipper(this.radius, this.position, this.shape, this.inflate);

  @override
  Path getClip(Size size) {
    if (shape == WidgetShape.square) {
      return Path()
        ..addRect(radius.inflate(5 + inflate))
        ..addRect(Rect.fromLTWH(0.0, 0.0, screenSize.width, screenSize.height))
        ..fillType = PathFillType.evenOdd;
    } else {
      return Path()
        ..addOval(Rect.fromCircle(center: radius.center, radius: radius.longestSide / 2).inflate(inflate))
        ..addRect(Rect.fromLTWH(0.0, 0.0, screenSize.width, screenSize.height))
        ..fillType = PathFillType.evenOdd;
    }
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
