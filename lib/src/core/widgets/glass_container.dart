import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  final double borderRadius;
  final double opacity;
  final Color? color;
  final Color? borderColor;
  final double borderWidth;

  // NOTE: 'blur' is kept in the constructor so you don't have to delete it
  // from all your other files, but it is ignored for performance.
  final double blur;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.borderRadius = 24,
    this.blur = 10,
    this.opacity = 0.1, // Lower default for better look without blur
    this.color,
    this.borderColor,
    this.borderWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    // Determine base color (defaulting to white/black based on theme)
    final Color baseColor = color ?? Theme.of(context).colorScheme.surface;
    final Color outlineColor = borderColor ?? Colors.black;

    return Padding(
      padding: margin,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            // ✅ HIGH PERFORMANCE BORDER: Adds a subtle shine
            border: Border.all(
              color: outlineColor.withOpacity(0.15),
              width: borderWidth,
            ),
            // ✅ HIGH PERFORMANCE GLASS: Uses gradients instead of Blur
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                baseColor.withOpacity(opacity + 0.1), // Top-left shine
                baseColor.withOpacity(opacity),       // Main body transparency
                baseColor.withOpacity(opacity - 0.05 < 0 ? 0 : opacity - 0.05), // Bottom fade
              ],
              stops: const [0.0, 0.4, 1.0],
            ),
            boxShadow: [
              // Subtle shadow to lift it off the background
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}