import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../provider/premium_provider.dart';

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
  bool _isLoadingAd = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = Colors.amber; // Premium Gold
    final baseGlassColor = Color.alphaBlend(
      primaryColor.withOpacity(0.1),
      Colors.black.withOpacity(0.6),
    );
    final borderColor = primaryColor.withOpacity(0.4);
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
                      color: primaryColor.withOpacity(0.15),
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
                        color: primaryColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.4),
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
                            color: Colors.black.withOpacity(0.5),
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
                        color: textColor.withOpacity(0.9),
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // "Watch Ad" Button (Primary Action)
                    if (widget.onUnlockOnce != null)
                      SizedBox(
                        width: double.infinity,
                        child: _GlassGradientButton(
                          text: _isLoadingAd
                              ? "Loading Ad..."
                              : "Watch Ad to Use Once",
                          icon: _isLoadingAd ? null : Icons.play_circle_fill,
                          isLoading: _isLoadingAd,
                          onPressed: _isLoadingAd
                              ? null
                              : () async {
                                  setState(() => _isLoadingAd = true);
                                  final provider = Provider.of<PremiumProvider>(
                                    context,
                                    listen: false,
                                  );

                                  // Wait for ad to be shown/completed
                                  await provider.showRewardedAd(
                                    onReward: (_) {
                                      widget.onUnlockOnce?.call();
                                    },
                                  );

                                  if (mounted) {
                                    Navigator.pop(context);
                                  }
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
                          side: BorderSide(color: textColor.withOpacity(0.3)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("Unlock Permanently"),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Cancel
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: textColor.withOpacity(0.6)),
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
                      Colors.white.withOpacity(0.15),
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
                  color: Colors.amber.withOpacity(0.4),
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
