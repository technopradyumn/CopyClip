import 'dart:ui';
import 'package:flutter/material.dart';

class GlassDialog extends StatelessWidget {
  final String title;
  final String content;
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
    // --- THEME EXTRACTION ---
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    // We use a dark base for the glass, tinted with the primary accent
    final baseGlassColor = Color.alphaBlend(
      primaryColor.withOpacity(0.15), // Tint of accent
      Colors.black.withOpacity(0.6),  // Dark base
    );
    final borderColor = primaryColor.withOpacity(0.3);
    final textColor = Colors.white; // Keep white for high contrast on dark glass

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        children: [
          // 1. The Blur (Frosted Base)
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: baseGlassColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: borderColor, width: 1),
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
                    // Title
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        shadows: [
                          Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 2))
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Content
                    Text(
                      content,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        color: textColor.withOpacity(0.85),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            if (onCancel != null) onCancel!();
                            else Navigator.pop(context);
                          },
                          child: Text(
                            cancelText,
                            style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _GlassButton(
                          text: confirmText,
                          // Use Red for destructive, otherwise use Theme Primary
                          color: isDestructive ? theme.colorScheme.error : primaryColor,
                          textColor: textColor,
                          onTap: () {
                            if (onConfirm != null) onConfirm!();
                            else Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. The "Reflection" Layer (Top Shine)
          Positioned.fill(
            child: IgnorePointer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0.0, 0.4, 1.0],
                      colors: [
                        Colors.white.withOpacity(0.15), // Subtle white shine
                        Colors.white.withOpacity(0.0),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 3. Rim Light Border (Accent Colored)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.2), // Accent rim
                    width: 1.5,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryColor.withOpacity(0.4), // Accent highlight top-left
                      Colors.transparent,
                      Colors.black.withOpacity(0.2), // Shadow bottom-right
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

// Small helper for the dialog buttons
class _GlassButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _GlassButton({
    required this.text,
    required this.color,
    required this.textColor,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          // Gradient button based on action color
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withOpacity(0.4),
              color.withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.6), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor, // Usually white for contrast
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 2, offset: const Offset(0, 1))
            ],
          ),
        ),
      ),
    );
  }
}