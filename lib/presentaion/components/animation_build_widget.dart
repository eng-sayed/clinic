import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimationAppearance extends StatefulWidget {
  AnimationAppearance(
      {Key? key,
      required this.child,
      this.alignment,
      this.duration,
      this.curve})
      : super(key: key);
  Widget child;
  Duration? duration;
  AlignmentGeometry? alignment;
  Curve? curve;
  @override
  State<AnimationAppearance> createState() => _AnimationAppearanceState();
}

class _AnimationAppearanceState extends State<AnimationAppearance> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        curve: widget.curve ?? Curves.bounceOut,
        duration: widget.duration ?? Duration(milliseconds: 1200),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, tween, child) {
          return Transform(
              alignment: widget.alignment ?? Alignment.bottomCenter,
              transform: Matrix4.identity()..scale(tween),
              child: widget.child);
        });
  }
}

class AnimationAppearanceOpacity extends StatefulWidget {
  AnimationAppearanceOpacity({Key? key, required this.child, this.duration})
      : super(key: key);
  Widget child;

  Duration? duration;
  @override
  State<AnimationAppearanceOpacity> createState() =>
      _AnimationAppearanceOpacityState();
}

class _AnimationAppearanceOpacityState
    extends State<AnimationAppearanceOpacity> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        duration: widget.duration ?? Duration(milliseconds: 1400),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, tween, child) {
          return Opacity(opacity: tween, child: widget.child);
        });
  }
}
