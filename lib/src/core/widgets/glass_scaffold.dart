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
  State<GlassScaffold> createState() => _GlassScaffoldState();
}

class _GlassScaffoldState extends State<GlassScaffold> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final baseColor =
        widget.backgroundColor ?? theme.scaffoldBackgroundColor;

    final bool isBackgroundDark =
        ThemeData.estimateBrightnessForColor(baseColor) ==
            Brightness.dark;

    final contentColor =
    isBackgroundDark ? Colors.white : Colors.black87;

    final overlayStyle = isBackgroundDark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: baseColor,

        // ❌ DO NOT let Scaffold resize automatically
        resizeToAvoidBottomInset: false,

        extendBodyBehindAppBar: true,

        appBar: widget.title != null
            ? AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          systemOverlayStyle: overlayStyle,
          leading: widget.showBackArrow
              ? IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: contentColor,
            ),
            onPressed: () => context.pop(),
          )
              : null,
          title: Text(
            widget.title!,
            style: theme.textTheme.titleLarge?.copyWith(
              color: contentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: widget.actions,
        )
            : null,

        body: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(color: baseColor),
              ),
            ),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      isBackgroundDark
                          ? Colors.white10
                          : Colors.white.withOpacity(0.6),
                      isBackgroundDark
                          ? Colors.transparent
                          : Colors.white.withOpacity(0.2),
                    ],
                  ),
                ),
              ),
            ),

            if (widget.enableGlassEffect)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(color: Colors.transparent),
                ),
              ),

            // ✅ Manual keyboard handling (THIS FIXES BLACK SCREEN)
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomInset),
                child: Material(
                  color: Colors.transparent,
                  child: widget.body,
                ),
              ),
            ),
          ],
        ),

        floatingActionButton: widget.floatingActionButton,
      ),
    );
  }
}
