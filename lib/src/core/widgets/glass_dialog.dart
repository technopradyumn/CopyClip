import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:copyclip/src/core/const/constant.dart';

class GlassDialog extends StatelessWidget {
  final String title;
  final dynamic content;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  const GlassDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
    this.cancelText = "Cancel",
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final baseGlassColor = Color.alphaBlend(
      primaryColor.withOpacity(0.15),
      Colors.black.withOpacity(0.6),
    );
    final borderColor = primaryColor.withOpacity(0.3);
    final textColor = Colors.white;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        children: [
          // 1. The Blur (Frosted Base)
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: baseGlassColor,
                  borderRadius: BorderRadius.circular(
                    AppConstants.cornerRadius,
                  ),
                  border: Border.all(
                    color: borderColor,
                    width: AppConstants.borderWidth,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // --- LOGIC: Handle String or Widget ---
                    if (content is String)
                      Text(
                        content,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          color: textColor.withOpacity(0.85),
                          height: 1.5,
                        ),
                      )
                    else
                      content as Widget, // Render the Color Picker directly

                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: onCancel ?? () => Navigator.pop(context),
                          child: Text(
                            cancelText,
                            style: TextStyle(
                              color: textColor.withOpacity(0.6),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _GlassButton(
                          text: confirmText,
                          color: isDestructive
                              ? theme.colorScheme.error
                              : primaryColor,
                          textColor: textColor,
                          onTap: onConfirm ?? () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Layers 2 and 3 (Reflection & Rim Light)
          Positioned.fill(
            child: IgnorePointer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0.0, 0.4, 1.0],
                      colors: [
                        Colors.white.withOpacity(0.15),
                        Colors.white.withOpacity(0.0),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppConstants.cornerRadius,
                  ),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.2),
                    width: AppConstants.borderWidth + 0.3,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryColor.withOpacity(0.4),
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                    ],
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

class _GlassButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;
  const _GlassButton({
    required this.text,
    required this.color,
    required this.textColor,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withOpacity(0.4), color.withOpacity(0.2)],
          ),
          borderRadius: BorderRadius.circular(AppConstants.cornerRadius * 0.5),
          border: Border.all(
            color: color.withOpacity(0.6),
            width: AppConstants.borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
