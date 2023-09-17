import 'package:flutter/material.dart';

class AlvysFloatingActionButtonAnimator extends FloatingActionButtonAnimator {
  static final Animatable<double> _animationTween = Tween<double>(
    begin: 1.0,
    end: 1.0,
  );
  @override
  Offset getOffset({required Offset begin, required Offset end, required double progress}) {
    return end;
  }

  @override
  Animation<double> getRotationAnimation({required Animation<double> parent}) {
    return _animationTween.animate(parent);
  }

  @override
  Animation<double> getScaleAnimation({required Animation<double> parent}) {
    return _animationTween.animate(parent);
  }
}
