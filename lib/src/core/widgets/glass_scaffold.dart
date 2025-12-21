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
  final bool resizeToAvoidBottomInset;

  const GlassScaffold({
    super.key,
    required this.body,
    this.floatingActionButton,
    this.title,
    this.actions,
    this.showBackArrow = false,
    this.backgroundColor,
    this.enableGlassEffect = true,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  State<GlassScaffold> createState() => _GlassScaffoldState();
}

class _GlassScaffoldState extends State<GlassScaffold> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final SystemUiOverlayStyle systemUiOverlayStyle = isDark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    final Color effectiveBackgroundColor = widget.backgroundColor ?? theme.scaffoldBackgroundColor;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        appBar: widget.title != null
            ? AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          systemOverlayStyle: systemUiOverlayStyle,
          leading: widget.showBackArrow
              ? IconButton(
            icon: Icon(Icons.arrow_back_ios_new, size: 20, color: colorScheme.onSurface),
            onPressed: () => context.pop(),
          )
              : null,
          title: Text(
            widget.title!,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
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
                decoration: BoxDecoration(color: effectiveBackgroundColor),
              ),
            ),

            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: widget.body,
              ),
            ),
          ],
        ),
        floatingActionButton: widget.floatingActionButton,
      ),
    );
  }
}