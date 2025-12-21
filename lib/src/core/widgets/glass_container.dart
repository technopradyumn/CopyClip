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
    this.blur = 3,
    this.opacity = 0.1,
    this.color,
  });

  @override
  State<GlassContainer> createState() => _GlassContainerState();
}

class _GlassContainerState extends State<GlassContainer> {
  @override
  Widget build(BuildContext context) {
    // If widget.color is provided, use it; otherwise use Theme surface color
    final Color effectiveBaseColor = widget.color ?? Theme.of(context).colorScheme.surface;
    final Color outlineColor = Theme.of(context).dividerColor;

    // Build the container content
    Widget content = Container(
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      decoration: BoxDecoration(
        // Always use opacity for glass effect
        color: effectiveBaseColor.withOpacity(widget.opacity),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: outlineColor.withOpacity(0.4),
          width: 1.5,
        ),
        // Always apply gradient
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            effectiveBaseColor.withOpacity(widget.opacity + 0.1),
            effectiveBaseColor.withOpacity(widget.opacity / 2),
          ],
        ),
      ),
      child: widget.child,
    );

    // If tap handler is present, wrap in GestureDetector
    if (widget.onTap != null) {
      content = GestureDetector(onTap: widget.onTap, child: content);
    }

    return Padding(
      padding: widget.margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        // Always apply BackdropFilter
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
          child: content,
        ),
      ),
    );
  }
}