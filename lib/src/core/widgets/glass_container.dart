import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  final double borderRadius;
  final double blur;
  final double opacity;
  final Color? color;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.borderRadius = 24,
    this.blur = 10, // Increased default blur for better glass effect
    this.opacity = 0.2, // Increased default opacity so colors are visible
    this.color,
  });

  @override
  State<GlassContainer> createState() => _GlassContainerState();
}

class _GlassContainerState extends State<GlassContainer> {
  @override
  Widget build(BuildContext context) {
    // Determine base color
    final Color baseColor = widget.color ?? Theme.of(context).colorScheme.surface;
    final Color outlineColor = Theme.of(context).dividerColor;

    // Helper to safely apply opacity (clamped between 0.0 and 1.0 to prevent crashes)
    Color safeOpacity(Color c, double o) => c.withOpacity(o.clamp(0.0, 1.0));

    return Padding(
      padding: widget.margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              width: widget.width,
              height: widget.height,
              padding: widget.padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  color: outlineColor.withOpacity(0.2),
                  width: 1.5,
                ),
                // BUG FIX: Removed 'color' property because it cannot be used with 'gradient'
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    // Richer colors: Top left is slightly more opaque
                    safeOpacity(baseColor, widget.opacity + 0.1),
                    // Bottom right is slightly more transparent
                    safeOpacity(baseColor, widget.opacity * 0.5),
                  ],
                ),
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}