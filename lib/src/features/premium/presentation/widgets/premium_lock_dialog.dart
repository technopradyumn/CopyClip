import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../bloc/premium_bloc.dart';
import '../bloc/premium_event.dart';
import '../bloc/premium_state.dart';

class PremiumLockDialog {
  static void show(
    BuildContext context, {
    required String featureName,
    VoidCallback? onUnlockOnce,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => _GlassPremiumDialog(
        featureName: featureName,
        onUnlockOnce: onUnlockOnce,
      ),
    );
  }
}

class _GlassPremiumDialog extends StatefulWidget {
  final String featureName;
  final VoidCallback? onUnlockOnce;

  const _GlassPremiumDialog({required this.featureName, this.onUnlockOnce});

  @override
  State<_GlassPremiumDialog> createState() => _GlassPremiumDialogState();
}

class _GlassPremiumDialogState extends State<_GlassPremiumDialog> {
  // We rely on Bloc state now, but local loading state for interaction feedback is also okay.
  // Actually, let's use Bloc state.

  @override
  void initState() {
    super.initState();
    // Preload if needed
    context.read<PremiumBloc>().add(LoadRewardedAd());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = Colors.amber; // Premium Gold
    final baseGlassColor = Color.alphaBlend(
      primaryColor.withValues(alpha: 0.1),
      Colors.black.withValues(alpha: 0.6),
    );
    final borderColor = primaryColor.withValues(alpha: 0.4);
    final textColor = Colors.white;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        children: [
          // 1. Frost & Base
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: baseGlassColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: borderColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.15),
                      blurRadius: 25,
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.4),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.workspace_premium,
                        color: primaryColor,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title
                    Text(
                      "Premium Feature",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Body
                    Text(
                      "The '${widget.featureName}' feature is available for Premium users only.",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: textColor.withValues(alpha: 0.9),
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // "Watch Ad" Button (Primary Action)
                    if (widget.onUnlockOnce != null)
                      SizedBox(
                        width: double.infinity,
                        child: BlocBuilder<PremiumBloc, PremiumState>(
                          builder: (context, state) {
                            final isLoading = state.isAdLoading;
                            final isReady = state.isAdReady;

                            // If loading, show loading.
                            // If not ready and not loading, trigger load and show "Retry/Loading".

                            return _GlassGradientButton(
                              text: isLoading
                                  ? "Loading Ad..."
                                  : (isReady
                                        ? "Watch Ad to Use Once"
                                        : "Load Ad"),
                              icon: isLoading ? null : Icons.play_circle_fill,
                              isLoading: isLoading,
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (!isReady) {
                                        context.read<PremiumBloc>().add(
                                          LoadRewardedAd(),
                                        );
                                      } else {
                                        context.read<PremiumBloc>().add(
                                          ShowRewardedAd(
                                            onReward: (reward) {
                                              widget.onUnlockOnce?.call();
                                              // We can close dialog here if we want
                                              // But usually ad covers screen.
                                              // After ad closes, user sees this dialog again?
                                              // We should probably close it automatically if success.
                                              if (mounted) {
                                                Navigator.pop(context);
                                              }
                                            },
                                          ),
                                        );
                                      }
                                    },
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 12),

                    // "Unlock Permanently" Button (Secondary Action)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.push(AppRouter.premium);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: textColor,
                          side: BorderSide(color: textColor.withValues(alpha: 0.3)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.unlockPermanently,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Cancel
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: textColor.withValues(alpha: 0.6)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Glossy Overlay
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.15),
                      Colors.transparent,
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassGradientButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _GlassGradientButton({
    required this.text,
    this.icon,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: onPressed != null
              ? [Colors.amber.shade400, Colors.amber.shade700]
              : [Colors.grey.shade600, Colors.grey.shade800],
        ),
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: Colors.amber.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                else if (icon != null) ...[
                  Icon(icon, color: Colors.black, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
