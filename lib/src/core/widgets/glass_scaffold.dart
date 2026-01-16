import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class GlassScaffold extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final String? title;
  final List<Widget>? actions;
  final bool showBackArrow;
  final Color? backgroundColor;
  // enableGlassEffect is now ignored for performance, or used to toggle gradients
  final bool enableGlassEffect;

  const GlassScaffold({
    super.key,
    required this.body,
    this.floatingActionButton,
    this.title,
    this.actions,
    this.showBackArrow = false,
    this.backgroundColor,
    this.enableGlassEffect = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = backgroundColor ?? theme.scaffoldBackgroundColor;
    final bool isDark = ThemeData.estimateBrightnessForColor(baseColor) == Brightness.dark;
    final contentColor = isDark ? Colors.white : Colors.black87;
    final overlayStyle = isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: baseColor,
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        appBar: title != null
            ? AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          systemOverlayStyle: overlayStyle,
          leading: showBackArrow
              ? IconButton(
            icon: Icon(Icons.arrow_back_ios_new, size: 20, color: contentColor),
            onPressed: () => context.pop(),
          )
              : null,
          title: Text(
            title!,
            style: theme.textTheme.titleLarge?.copyWith(
              color: contentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: actions,
        )
            : null,
        body: Stack(
          children: [
            // 1. Solid Background
            Positioned.fill(
              child: ColoredBox(color: baseColor),
            ),

            // 2. High-Performance Gradient Overlay (Replaces Blur)
            // This mimics the depth of glass without the expensive calculation
            if (enableGlassEffect)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [Colors.white.withOpacity(0.05), Colors.transparent]
                          : [Colors.white.withOpacity(0.4), Colors.white.withOpacity(0.1)],
                    ),
                  ),
                ),
              ),

            // 3. Body Content (SafeArea applied here)
            Positioned.fill(
              child: SafeArea(
                // Remove bottom SafeArea if you want content to go behind nav bar,
                // but usually true is safer for lists
                bottom: false,
                child: body,
              ),
            ),
          ],
        ),
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}