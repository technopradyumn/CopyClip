import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:copyclip/src/core/widgets/glass_dialog.dart';

class CongratulationsWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onDismiss;

  const CongratulationsWidget({
    super.key,
    required this.title,
    required this.message,
    required this.onDismiss,
  });

  static void show(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (context) => CongratulationsWidget(
        title: title,
        message: message,
        onDismiss: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassDialog(
      title: title,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          SvgPicture.asset(
                'assets/images/congratulations.svg',
                width: 150,
                height: 150,
              )
              .animate()
              .fade(duration: 500.ms)
              .scale(duration: 500.ms, curve: Curves.elasticOut)
              .shimmer(delay: 1000.ms, duration: 1500.ms),

          const SizedBox(height: 24),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ).animate().fade(delay: 300.ms).moveY(begin: 10, end: 0),
        ],
      ),
      confirmText: "Awesome!",
      onConfirm: onDismiss,
    );
  }
}
