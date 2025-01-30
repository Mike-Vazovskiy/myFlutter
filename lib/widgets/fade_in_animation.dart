import 'package:flutter/material.dart';

class FadeInAnimation extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const FadeInAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration,
      curve: curve,
      builder: (context, value, childWidget) {
        return Opacity(
          opacity: value,
          child: childWidget,
        );
      },
      child: child,
    );
  }
}
