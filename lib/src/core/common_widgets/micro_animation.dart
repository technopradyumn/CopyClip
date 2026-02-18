import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum AnimationType { pop, slide, fade, scale }

class MicroAnimation extends StatelessWidget {
  final Widget child;
  final AnimationType type;
  final Duration delay;
  final Duration duration;

  const MicroAnimation({
    super.key,
    required this.child,
    this.type = AnimationType.pop,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  Widget build(BuildContext context) {
    var animation = child.animate(delay: delay);

    switch (type) {
      case AnimationType.pop:
        return animation
            .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.0, 1.0),
              curve: Curves.easeOutBack,
              duration: duration,
            )
            .fadeIn(duration: duration);
      case AnimationType.slide:
        return animation
            .slideY(
              begin: 0.2,
              end: 0.0,
              curve: Curves.easeOutCubic,
              duration: duration,
            )
            .fadeIn(duration: duration);
      case AnimationType.fade:
        return animation.fadeIn(duration: duration);
      case AnimationType.scale:
        return animation.scale(
          begin: const Offset(0.0, 0.0),
          end: const Offset(1.0, 1.0),
          curve: Curves.elasticOut,
          duration: duration,
        );
    }
  }
}
