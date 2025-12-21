import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class GlassScaffold extends StatefulWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final String? title;
  final List<Widget>? actions;
  final bool showBackArrow;
  final Color? backgroundColor;
  final bool enableGlassEffect; // New: Toggle to disable orbs/blur

  const GlassScaffold({
    super.key,
    required this.body,
    this.floatingActionButton,
    this.title,
    this.actions,
    this.showBackArrow = false,
    this.backgroundColor,
    this.enableGlassEffect = true, // Default to true (Glass mode)
  });

  @override
  State<GlassScaffold> createState() => _GlassScaffoldState();
}

class _GlassScaffoldState extends State<GlassScaffold> {
  @override
  Widget build(BuildContext context) {
    // Get theme colors
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Status Bar Logic
    final SystemUiOverlayStyle systemUiOverlayStyle = isDark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    // Logic: Use passed background color OR fallback to theme default
    final Color effectiveBackgroundColor = widget.backgroundColor ?? theme.scaffoldBackgroundColor;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: effectiveBackgroundColor, // Apply directly to Scaffold for safety
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: widget.title != null
            ? AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          systemOverlayStyle: systemUiOverlayStyle,
          leading: widget.showBackArrow
              ? IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: theme.iconTheme.color),
            onPressed: () => context.pop(),
          )
              : null,
          title: Text(
            widget.title!,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: widget.actions,
        )
            : null,
        body: Stack(
          children: [
            // 1. BACKGROUND LAYER
            Positioned.fill(
              child: Container(
                color: effectiveBackgroundColor,
                child: widget.enableGlassEffect
                    ? Stack(
                  children: [
                    // Render Orbs only if Glass Effect is enabled
                    Positioned(
                        top: -100,
                        left: -100,
                        child: _buildOrb(colorScheme.primary.withOpacity(0.15), 400)
                    ),
                    Positioned(
                        bottom: -100,
                        right: -100,
                        child: _buildOrb(colorScheme.secondary.withOpacity(0.15), 350)
                    ),
                    Positioned(
                        top: 300,
                        right: -80,
                        child: _buildOrb(theme.dividerColor.withOpacity(0.1), 250)
                    ),
                  ],
                )
                    : null, // No orbs if disabled
              ),
            ),

            // 2. BLUR LAYER (Only if enabled)
            if (widget.enableGlassEffect)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                  child: Container(color: Colors.transparent),
                ),
              ),

            // 3. CONTENT LAYER
            SafeArea(
              top: widget.title == null,
              bottom: false,
              child: Column(
                children: [
                  Expanded(child: widget.body),
                  // Keyboard handling
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: widget.floatingActionButton,
      ),
    );
  }

  Widget _buildOrb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 100,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}