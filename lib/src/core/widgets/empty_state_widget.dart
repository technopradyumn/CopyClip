import 'package:copyclip/src/core/const/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? subMessage;
  final VoidCallback? onAction;
  final String? actionLabel;
  final String? assetPath; // Added

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.subMessage,
    this.onAction,
    this.actionLabel,
    this.assetPath, // Added
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurfaceColor = theme.colorScheme.onSurface;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
                  assetPath ??
                      'assets/images/empty_state.svg', // Use custom or default
                  width: 180,
                  height: 180,
                )
                .animate()
                .fade(duration: 600.ms)
                .scale(
                  delay: 200.ms,
                  duration: 400.ms,
                  curve: Curves.easeOutBack,
                ),

            const SizedBox(height: 24),

            Text(
                  message,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: onSurfaceColor.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fade(delay: 400.ms, duration: 400.ms)
                .moveY(begin: 10, end: 0),

            if (subMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                    subMessage!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: onSurfaceColor.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fade(delay: 500.ms, duration: 400.ms)
                  .moveY(begin: 10, end: 0),
            ],

            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add_rounded),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.cornerRadius,
                    ),
                  ),
                ),
              ).animate().fade(delay: 600.ms, duration: 400.ms).scale(),
            ],
          ],
        ),
      ),
    );
  }
}
